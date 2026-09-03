package com.ammapickles.order.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@FeignClient(name = "cart-service", url = "${cart.service.url}")
public interface CartClient {

    @GetMapping("/api/cart/user/{userId}")
    CartResponse getUserCart(@PathVariable Long userId);

    @DeleteMapping("/api/cart/user/{userId}/clear")
    void clearCart(@PathVariable Long userId);

    record CartResponse(
            Long cartId,
            Long userId,
            List<CartItemResponse> items,
            Integer totalItems,
            BigDecimal cartTotal,
            boolean freeDelivery
    ) {}

    record CartItemResponse(
            Long cartItemId,
            Long productId,
            Long variantId,
            String productName,
            BigDecimal price,
            Integer quantity,
            BigDecimal itemTotal,
            String sizeLabel
    ) {}
}
