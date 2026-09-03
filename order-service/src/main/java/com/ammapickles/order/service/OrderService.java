package com.ammapickles.order.service;

import com.ammapickles.order.dto.OrderRequest;
import com.ammapickles.order.dto.OrderResponse;
import com.ammapickles.order.entity.OrderStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface OrderService {

    List<OrderResponse> getOrdersByUser(Long userId);

    OrderResponse getOrderByIdForUser(Long orderId, Long userId);

    OrderResponse placeOrder(Long userId, OrderRequest request);

    void cancelOrder(Long orderId, Long userId);

    Page<OrderResponse> getAllOrders(Pageable pageable);

    OrderResponse getOrderById(Long orderId);

    OrderResponse updateOrderStatus(Long orderId, String status);

    Page<OrderResponse> getOrdersByStatus(
            OrderStatus status,
            Pageable pageable
    );

    long getOrderCountByUser(Long userId);
}
