package com.ammapickles.notification.kafka;

import com.ammapickles.notification.dto.OrderConfirmationRequest;
import com.ammapickles.notification.event.OrderCreatedEvent;
import com.ammapickles.notification.service.NotificationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class OrderCreatedEventConsumer {

    private final ObjectMapper objectMapper;
    private final NotificationService notificationService;

    @KafkaListener(
            topics = "${app.kafka.topic.order-created}",
            groupId = "notification-service"
    )
    public void consume(String message) {

        try {
            OrderCreatedEvent event =
                    objectMapper.readValue(message, OrderCreatedEvent.class);

            log.info(
                    "Received OrderCreatedEvent. orderId={}, eventId={}",
                    event.getOrderId(),
                    event.getEventId()
            );

            List<OrderConfirmationRequest.OrderItemRequest> items =
                    event.getItems()
                            .stream()
                            .map(item -> OrderConfirmationRequest.OrderItemRequest.builder()
                                    .productName(item.getProductName())
                                    .quantity(item.getQuantity())
                                    .price(item.getPrice())
                                    .build())
                            .toList();

            OrderConfirmationRequest request =
                    OrderConfirmationRequest.builder()
                            .email(event.getEmail())
                            .orderId(event.getOrderId())
                            .totalAmount(event.getTotalAmount())
                            .deliveryCharge(event.getDeliveryCharge())
                            .grandTotal(event.getGrandTotal())
                            .items(items)
                            .build();

            boolean sent =
                    notificationService.sendOrderConfirmationEmail(request);

            if (sent) {
                log.info(
                        "Order confirmation email processed successfully. orderId={}",
                        event.getOrderId()
                );
            } else {
                log.error(
                        "Order confirmation email failed. orderId={}",
                        event.getOrderId()
                );

                throw new RuntimeException(
                        "Order confirmation email failed"
                );
            }

        } catch (Exception e) {
            log.error(
                    "Failed to process OrderCreatedEvent",
                    e
            );

            throw new RuntimeException(
                    "Failed to process OrderCreatedEvent",
                    e
            );
        }
    }
}
