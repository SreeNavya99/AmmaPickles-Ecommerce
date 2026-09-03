package com.ammapickles.cart.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.math.BigDecimal;

@FeignClient(
        name = "product-service",
        url = "${product.service.url}"
)
public interface ProductClient {

    @GetMapping("/api/products/{id}")
    ProductResponse getProductById(@PathVariable Long id);

    record ProductResponse(
            Long id,
            String name,
            String description,
            BigDecimal price,
            String size,
            Integer quantity,
            Long categoryId
    ) {
        public boolean isInStock() {
            return quantity != null && quantity > 0;
        }
    }
}
