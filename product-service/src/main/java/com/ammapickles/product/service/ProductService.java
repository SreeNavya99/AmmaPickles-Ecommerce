package com.ammapickles.product.service;

import com.ammapickles.product.entity.Product;

import java.util.List;

public interface ProductService {

    List<Product> getAllProducts();

    Product getProductById(Long id);

    List<Product> getProductsByCategory(Long categoryId);

    List<Product> searchProducts(String name);

    Product createProduct(Product product);

    Product updateProduct(Long id, Product product);

    void deleteProduct(Long id);
}

