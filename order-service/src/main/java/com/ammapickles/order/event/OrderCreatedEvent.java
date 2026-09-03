package com.ammapickles.order.event;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderCreatedEvent {

    private String eventId;
    private Long orderId;
    private Long userId;
    private String email;

    private BigDecimal totalAmount;
    private BigDecimal deliveryCharge;
    private BigDecimal grandTotal;

    private LocalDateTime orderDate;

    private List<OrderItemEvent> items;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class OrderItemEvent {

        private String productName;
        private Integer quantity;
        private BigDecimal price;
    }
}
