package com.ammapickles.cart.service;

import com.ammapickles.cart.client.OrderClient;
import com.ammapickles.cart.client.ProductClient;
import com.ammapickles.cart.client.UserClient;
import com.ammapickles.cart.dto.CartItemResponse;
import com.ammapickles.cart.dto.CartResponse;
import com.ammapickles.cart.entity.Cart;
import com.ammapickles.cart.entity.CartItem;
import com.ammapickles.cart.repository.CartItemRepository;
import com.ammapickles.cart.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductClient productClient;
    private final UserClient userClient;
    private final OrderClient orderClient;

    private static final BigDecimal FREE_DELIVERY_ABOVE = BigDecimal.valueOf(1000);
    private static final BigDecimal FIRST_ORDER_FREE_ABOVE = BigDecimal.valueOf(500);

    @Override
    @Transactional
    public CartResponse getUserCart(Long userId) {
        log.info("Fetching cart for user: {}", userId);

        Cart cart = getOrCreateCart(userId);
        return mapToResponse(cart, userId);
    }

    @Override
    @Transactional
    public CartResponse addToCart(Long userId, Long productId, int quantity) {

        log.info("Adding product {} to cart for user {}", productId, userId);

        validateQuantity(quantity);

        ProductClient.ProductResponse product =
                productClient.getProductById(productId);

        validateProductStock(product, quantity);

        Cart cart = getOrCreateCart(userId);

        CartItem existingItem = cart.getItems()
                .stream()
                .filter(item -> item.getProductId().equals(productId))
                .findFirst()
                .orElse(null);

        if (existingItem != null) {

            int updatedQuantity = existingItem.getQuantity() + quantity;

            if (product.quantity() < updatedQuantity) {
                throw new IllegalStateException(
                        "Insufficient stock. Available: " + product.quantity());
            }

            existingItem.setQuantity(updatedQuantity);

        } else {

            CartItem newItem = CartItem.builder()
                    .cart(cart)
                    .productId(product.id())
                    .productName(product.name())
                    .priceSnapshot(product.price())
                    .sizeLabel(product.size())
                    .quantity(quantity)
                    .build();

            cart.getItems().add(newItem);
        }

        Cart saved = cartRepository.save(cart);

        return mapToResponse(saved, userId);
    }

    @Override
    @Transactional
    public CartResponse updateCartItem(
            Long cartItemId,
            int quantity,
            Long requestingUserId) {

        validateQuantity(quantity);

        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Cart item not found: " + cartItemId));

        validateCartOwnership(item, requestingUserId);

        ProductClient.ProductResponse product =
                productClient.getProductById(item.getProductId());

        validateProductStock(product, quantity);

        item.setQuantity(quantity);

        cartItemRepository.save(item);

        return mapToResponse(item.getCart(), requestingUserId);
    }

    @Override
    @Transactional
    public void removeCartItem(
            Long cartItemId,
            Long requestingUserId) {

        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Cart item not found: " + cartItemId));

        validateCartOwnership(item, requestingUserId);

        cartItemRepository.delete(item);

        log.info("Cart item removed: {}", cartItemId);
    }

    @Override
    @Transactional
    public void clearCart(Long userId) {

        log.info("Clearing cart for user: {}", userId);

        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Cart not found for user: " + userId));

        cart.getItems().clear();

        cartRepository.save(cart);
    }

    private Cart getOrCreateCart(Long userId) {

        return cartRepository.findByUserId(userId)
                .orElseGet(() -> {

                    log.info(
                            "No cart found for user {} - creating new cart",
                            userId);

                    userClient.getUserById(userId);

                    return cartRepository.save(
                            Cart.builder()
                                    .userId(userId)
                                    .build());
                });
    }

    private boolean calculateFreeDelivery(
            BigDecimal total,
            Long userId) {

        if (total.compareTo(FREE_DELIVERY_ABOVE) >= 0) {
            return true;
        }

        long orderCount = orderClient.getOrderCountByUserId(userId);

        return orderCount == 0
                && total.compareTo(FIRST_ORDER_FREE_ABOVE) >= 0;
    }

    private CartResponse mapToResponse(
            Cart cart,
            Long userId) {

        List<CartItemResponse> itemResponses =
                cart.getItems()
                        .stream()
                        .map(item -> {

                            BigDecimal itemTotal =
                                    item.getPriceSnapshot()
                                            .multiply(
                                                    BigDecimal.valueOf(
                                                            item.getQuantity()));

                            return CartItemResponse.builder()
                                    .cartItemId(item.getId())
                                    .productId(item.getProductId())
                                    .variantId(item.getProductId())
                                    .productName(item.getProductName())
                                    .price(item.getPriceSnapshot())
                                    .quantity(item.getQuantity())
                                    .itemTotal(itemTotal)
                                    .sizeLabel(item.getSizeLabel())
                                    .build();
                        })
                        .toList();

        BigDecimal total = cart.getCartTotal();

        boolean freeDelivery =
                calculateFreeDelivery(total, userId);

        return CartResponse.builder()
                .cartId(cart.getId())
                .userId(cart.getUserId())
                .items(itemResponses)
                .totalItems(cart.getItems().size())
                .cartTotal(total)
                .freeDelivery(freeDelivery)
                .build();
    }

    private void validateQuantity(int quantity) {

        if (quantity <= 0) {
            throw new IllegalArgumentException(
                    "Quantity must be at least 1");
        }
    }

    private void validateProductStock(
            ProductClient.ProductResponse product,
            int requestedQuantity) {

        if (product == null) {
            throw new RuntimeException("Product not found");
        }

        if (!product.isInStock()) {
            throw new IllegalStateException(
                    "Product is out of stock: " + product.name());
        }

        if (product.quantity() < requestedQuantity) {
            throw new IllegalStateException(
                    "Insufficient stock. Available: "
                            + product.quantity());
        }
    }

    private void validateCartOwnership(
            CartItem item,
            Long requestingUserId) {

        if (!item.getCart()
                .getUserId()
                .equals(requestingUserId)) {

            throw new IllegalStateException(
                    "Access denied to cart item: "
                            + item.getId());
        }
    }
}
