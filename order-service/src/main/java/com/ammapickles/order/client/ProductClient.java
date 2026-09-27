package com.ammapickles.order.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@FeignClient(name = "product-service", url = "${product.service.url}")
public interface ProductClient {

    @GetMapping("/api/products/{id}")
    ProductResponse getProductById(@PathVariable Long id);

    @PutMapping("/api/products/{id}")
    ProductResponse updateProduct(
            @PathVariable Long id,
            @RequestBody ProductUpdateRequest request
    );

    record ProductResponse(
            Long id,
            String name,
            String description,
            BigDecimal price,
            String size,
            Integer quantity,
            Long categoryId
    ) {}

    record ProductUpdateRequest(
            String name,
            String description,
            BigDecimal price,
            String size,
            Integer quantity,
            Long categoryId
    ) {}
}
