package com.ammapickles.cart.service;

import com.ammapickles.cart.dto.CartResponse;

public interface CartService {

    CartResponse getUserCart(Long userId);

    CartResponse addToCart(Long userId, Long productId, int quantity);

    CartResponse updateCartItem(Long cartItemId, int quantity, Long requestingUserId);

    void removeCartItem(Long cartItemId, Long requestingUserId);

    void clearCart(Long userId);
}
