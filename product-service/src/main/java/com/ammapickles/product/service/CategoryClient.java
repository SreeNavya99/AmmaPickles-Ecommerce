package com.ammapickles.product.service;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(
        name = "category-service",
        url = "${category.service.url}"
)
public interface CategoryClient {

    @GetMapping("/api/categories/{id}")
    CategoryResponse getCategoryById(@PathVariable Long id);

    record CategoryResponse(Long id, String name) {
    }
}

