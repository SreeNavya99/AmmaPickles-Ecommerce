package com.ammapickles.order.controller;

import com.ammapickles.order.dto.OrderRequest;
import com.ammapickles.order.dto.OrderResponse;
import com.ammapickles.order.entity.OrderStatus;
import com.ammapickles.order.service.OrderService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<OrderResponse>> getOrdersByUser(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                orderService.getOrdersByUser(userId));
    }

    @GetMapping("/{orderId}/user/{userId}")
    public ResponseEntity<OrderResponse> getOrderByIdForUser(
            @PathVariable Long orderId,
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                orderService.getOrderByIdForUser(
                        orderId, userId));
    }

    @PostMapping("/user/{userId}")
    public ResponseEntity<OrderResponse> placeOrder(
            @PathVariable Long userId,
            @Valid @RequestBody OrderRequest request) {

        return ResponseEntity.ok(
                orderService.placeOrder(userId, request));
    }

    @PostMapping("/{orderId}/user/{userId}/cancel")
    public ResponseEntity<Void> cancelOrder(
            @PathVariable Long orderId,
            @PathVariable Long userId) {

        orderService.cancelOrder(orderId, userId);

        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public ResponseEntity<Page<OrderResponse>> getAllOrders(
            Pageable pageable) {

        return ResponseEntity.ok(
                orderService.getAllOrders(pageable));
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<OrderResponse> getOrderById(
            @PathVariable Long orderId) {

        return ResponseEntity.ok(
                orderService.getOrderById(orderId));
    }

    @PutMapping("/{orderId}/status")
    public ResponseEntity<OrderResponse> updateOrderStatus(
            @PathVariable Long orderId,
            @RequestParam String status) {

        return ResponseEntity.ok(
                orderService.updateOrderStatus(
                        orderId, status));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<Page<OrderResponse>> getOrdersByStatus(
            @PathVariable OrderStatus status,
            Pageable pageable) {

        return ResponseEntity.ok(
                orderService.getOrdersByStatus(
                        status, pageable));
    }

    @GetMapping("/user/{userId}/count")
    public ResponseEntity<Long> getOrderCountByUser(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                orderService.getOrderCountByUser(userId));
    }
}
