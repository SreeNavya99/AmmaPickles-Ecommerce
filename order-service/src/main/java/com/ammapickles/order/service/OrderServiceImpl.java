package com.ammapickles.order.service;

import com.ammapickles.order.client.*;
import com.ammapickles.order.dto.OrderItemResponse;
import com.ammapickles.order.dto.OrderRequest;
import com.ammapickles.order.dto.OrderResponse;
import com.ammapickles.order.entity.Order;
import com.ammapickles.order.entity.OrderItem;
import com.ammapickles.order.entity.OrderStatus;
import com.ammapickles.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private static final BigDecimal STANDARD_DELIVERY_CHARGE =
            BigDecimal.valueOf(70);

    private static final BigDecimal FREE_DELIVERY_ABOVE =
            BigDecimal.valueOf(1000);

    private static final BigDecimal FIRST_ORDER_FREE_ABOVE =
            BigDecimal.valueOf(500);

    private final OrderRepository orderRepository;
    private final UserClient userClient;
    private final AddressClient addressClient;
    private final CartClient cartClient;
    private final ProductClient productClient;
    private final NotificationClient notificationClient;

    @Override
    public List<OrderResponse> getOrdersByUser(Long userId) {

        validateUser(userId);

        return orderRepository
                .findByUserIdOrderByOrderDateDesc(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public OrderResponse getOrderByIdForUser(
            Long orderId,
            Long userId) {

        Order order = getOrder(orderId);

        if (!order.getUserId().equals(userId)) {
            throw new IllegalStateException(
                    "Access denied to order: " + orderId);
        }

        return mapToResponse(order);
    }

    @Override
    @Transactional
    public OrderResponse placeOrder(
            Long userId,
            OrderRequest request) {

        log.info("Placing order for user {}", userId);

        UserClient.UserResponse user = validateUser(userId);

        addressClient.getAddress(request.getAddressId(), userId);

        CartClient.CartResponse cart =
                cartClient.getUserCart(userId);

        if (cart.items() == null || cart.items().isEmpty()) {
            throw new IllegalStateException("Cart is empty");
        }

        BigDecimal totalAmount = cart.cartTotal();

        long previousOrders =
                orderRepository.countByUserId(userId);

        BigDecimal deliveryCharge =
                calculateDeliveryCharge(
                        totalAmount,
                        previousOrders);

        Order order = Order.builder()
                .userId(userId)
                .addressId(request.getAddressId())
                .totalAmount(totalAmount)
                .deliveryCharge(deliveryCharge)
                .status(OrderStatus.CONFIRMED)
                .build();

        for (CartClient.CartItemResponse cartItem :
                cart.items()) {

            ProductClient.ProductResponse product =
                    productClient.getProductById(
                            cartItem.productId());

            if (product == null) {
                throw new IllegalStateException(
                        "Product not found: " +
                        cartItem.productId());
            }

            int availableStock =
                    product.quantity() == null
                            ? 0
                            : product.quantity();

            if (availableStock < cartItem.quantity()) {
                throw new IllegalStateException(
                        "Insufficient stock for product: " +
                        product.name());
            }

            int remainingStock =
                    availableStock - cartItem.quantity();

            productClient.updateProduct(
                    product.id(),
                    new ProductClient.ProductUpdateRequest(
                            product.name(),
                            product.description(),
                            product.price(),
                            product.size(),
                            remainingStock,
                            product.categoryId()
                    )
            );

            OrderItem orderItem = OrderItem.builder()
                    .order(order)
                    .productId(product.id())
                    .productName(product.name())
                    .quantity(cartItem.quantity())
                    .price(cartItem.price())
                    .build();

            order.getItems().add(orderItem);
        }

        Order savedOrder = orderRepository.save(order);

        cartClient.clearCart(userId);

        sendConfirmationEmail(user, savedOrder);

        return mapToResponse(savedOrder);
    }

    @Override
    @Transactional
    public void cancelOrder(
            Long orderId,
            Long userId) {

        Order order = getOrder(orderId);

        if (!order.getUserId().equals(userId)) {
            throw new IllegalStateException(
                    "Access denied to order: " + orderId);
        }

        if (order.getStatus() != OrderStatus.CONFIRMED
                && order.getStatus() != OrderStatus.PENDING) {

            throw new IllegalStateException(
                    "Order cannot be cancelled in status: " +
                    order.getStatus());
        }

        for (OrderItem item : order.getItems()) {

            ProductClient.ProductResponse product =
                    productClient.getProductById(
                            item.getProductId());

            if (product != null) {

                int currentStock =
                        product.quantity() == null
                                ? 0
                                : product.quantity();

                productClient.updateProduct(
                        product.id(),
                        new ProductClient.ProductUpdateRequest(
                                product.name(),
                                product.description(),
                                product.price(),
                                product.size(),
                                currentStock + item.getQuantity(),
                                product.categoryId()
                        )
                );
            }
        }

        order.setStatus(OrderStatus.CANCELLED);

        orderRepository.save(order);

        log.info("Order {} cancelled", orderId);
    }

    @Override
    public Page<OrderResponse> getAllOrders(Pageable pageable) {

        return orderRepository.findAll(pageable)
                .map(this::mapToResponse);
    }

    @Override
    public OrderResponse getOrderById(Long orderId) {
        return mapToResponse(getOrder(orderId));
    }

    @Override
    @Transactional
    public OrderResponse updateOrderStatus(
            Long orderId,
            String status) {

        Order order = getOrder(orderId);

        OrderStatus newStatus;

        try {
            newStatus = OrderStatus.valueOf(
                    status.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(
                    "Invalid order status: " + status);
        }

        order.setStatus(newStatus);

        return mapToResponse(
                orderRepository.save(order));
    }

    @Override
    public Page<OrderResponse> getOrdersByStatus(
            OrderStatus status,
            Pageable pageable) {

        return orderRepository
                .findByStatus(status, pageable)
                .map(this::mapToResponse);
    }

    @Override
    public long getOrderCountByUser(Long userId) {
        return orderRepository.countByUserId(userId);
    }

    private UserClient.UserResponse validateUser(Long userId) {

        UserClient.UserResponse user =
                userClient.getUserById(userId);

        if (user == null || !user.enabled()) {
            throw new IllegalStateException(
                    "User is not available: " + userId);
        }

        return user;
    }

    private Order getOrder(Long orderId) {

        return orderRepository.findById(orderId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Order not found: " + orderId));
    }

    private BigDecimal calculateDeliveryCharge(
            BigDecimal total,
            long previousOrders) {

        if (total.compareTo(FREE_DELIVERY_ABOVE) >= 0) {
            return BigDecimal.ZERO;
        }

        if (previousOrders == 0
                && total.compareTo(FIRST_ORDER_FREE_ABOVE) >= 0) {
            return BigDecimal.ZERO;
        }

        return STANDARD_DELIVERY_CHARGE;
    }

    private void sendConfirmationEmail(
            UserClient.UserResponse user,
            Order order) {

        try {

            List<NotificationClient.OrderItemRequest> items =
                    order.getItems()
                            .stream()
                            .map(item ->
                                    new NotificationClient.OrderItemRequest(
                                            item.getProductName(),
                                            item.getQuantity(),
                                            item.getPrice()
                                    ))
                            .toList();

            notificationClient.sendOrderConfirmation(
                    new NotificationClient.OrderConfirmationRequest(
                            user.email(),
                            order.getId(),
                            order.getTotalAmount(),
                            order.getDeliveryCharge(),
                            order.getGrandTotal(),
                            items
                    )
            );

        } catch (Exception e) {

            log.error(
                    "Failed to send order confirmation for order {}",
                    order.getId(),
                    e
            );
        }
    }

    private OrderResponse mapToResponse(Order order) {

        List<OrderItemResponse> items =
                order.getItems()
                        .stream()
                        .map(item ->
                                OrderItemResponse.builder()
                                        .id(item.getId())
                                        .productId(item.getProductId())
                                        .productName(item.getProductName())
                                        .quantity(item.getQuantity())
                                        .price(item.getPrice())
                                        .itemTotal(
                                                item.getPrice()
                                                        .multiply(
                                                                BigDecimal.valueOf(
                                                                        item.getQuantity()))
                                        )
                                        .build()
                        )
                        .toList();

        return OrderResponse.builder()
                .id(order.getId())
                .userId(order.getUserId())
                .addressId(order.getAddressId())
                .totalAmount(order.getTotalAmount())
                .deliveryCharge(order.getDeliveryCharge())
                .grandTotal(order.getGrandTotal())
                .status(order.getStatus())
                .orderDate(order.getOrderDate())
                .items(items)
                .build();
    }
}
