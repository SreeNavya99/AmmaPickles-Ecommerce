package com.ammapickles.cart.controller;

import com.ammapickles.cart.dto.CartResponse;
import com.ammapickles.cart.service.CartService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<CartResponse> getUserCart(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                cartService.getUserCart(userId));
    }

    @PostMapping("/user/{userId}/product/{productId}")
    public ResponseEntity<CartResponse> addToCart(
            @PathVariable Long userId,
            @PathVariable Long productId,
            @RequestParam(defaultValue = "1") int quantity) {

        return ResponseEntity.ok(
                cartService.addToCart(
                        userId,
                        productId,
                        quantity));
    }

    @PutMapping("/item/{cartItemId}")
    public ResponseEntity<CartResponse> updateCartItem(
            @PathVariable Long cartItemId,
            @RequestParam int quantity,
            @RequestHeader("X-User-Id") Long userId) {

        return ResponseEntity.ok(
                cartService.updateCartItem(
                        cartItemId,
                        quantity,
                        userId));
    }

    @DeleteMapping("/item/{cartItemId}")
    public ResponseEntity<Void> removeCartItem(
            @PathVariable Long cartItemId,
            @RequestHeader("X-User-Id") Long userId) {

        cartService.removeCartItem(
                cartItemId,
                userId);

        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/user/{userId}/clear")
    public ResponseEntity<Void> clearCart(
            @PathVariable Long userId) {

        cartService.clearCart(userId);

        return ResponseEntity.noContent().build();
    }
}
