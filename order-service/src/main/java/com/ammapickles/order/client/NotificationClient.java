package com.ammapickles.order.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.math.BigDecimal;
import java.util.List;

@FeignClient(
        name = "notification-service",
        url = "${notification.service.url}"
)
public interface NotificationClient {

    @PostMapping("/api/notifications/order-confirmation")
    void sendOrderConfirmation(
            @RequestBody OrderConfirmationRequest request
    );

    record OrderConfirmationRequest(
            String email,
            Long orderId,
            BigDecimal totalAmount,
            BigDecimal deliveryCharge,
            BigDecimal grandTotal,
            List<OrderItemRequest> items
    ) {}

    record OrderItemRequest(
            String productName,
            Integer quantity,
            BigDecimal price
    ) {}
}
