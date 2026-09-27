package com.ammapickles.cart.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(
        name = "order-service",
        url = "${order.service.url}"
)
public interface OrderClient {

    @GetMapping("/api/orders/user/{userId}/count")
    long getOrderCountByUserId(@PathVariable Long userId);
}
