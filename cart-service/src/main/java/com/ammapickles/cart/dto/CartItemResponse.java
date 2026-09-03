package com.ammapickles.cart.dto;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItemResponse {

    private Long cartItemId;
    private Long productId;
    private Long variantId;
    private String productName;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal itemTotal;
    private String sizeLabel;
}
