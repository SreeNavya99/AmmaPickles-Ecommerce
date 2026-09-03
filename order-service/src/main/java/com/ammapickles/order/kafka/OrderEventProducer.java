package com.ammapickles.order.kafka;

import com.ammapickles.order.event.OrderCreatedEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class OrderEventProducer {

    private final KafkaTemplate<String, String> kafkaTemplate;
    private final ObjectMapper objectMapper;

    @Value("${app.kafka.topic.order-created}")
    private String orderCreatedTopic;

    public void publishOrderCreated(OrderCreatedEvent event) {

        try {
            String message = objectMapper.writeValueAsString(event);

            kafkaTemplate.send(
                    orderCreatedTopic,
                    String.valueOf(event.getOrderId()),
                    message
            ).whenComplete((result, exception) -> {

                if (exception != null) {
                    log.error(
                            "Failed to publish OrderCreatedEvent. orderId={}",
                            event.getOrderId(),
                            exception
                    );
                } else {
                    log.info(
                            "OrderCreatedEvent published successfully. orderId={}, topic={}, partition={}, offset={}",
                            event.getOrderId(),
                            result.getRecordMetadata().topic(),
                            result.getRecordMetadata().partition(),
                            result.getRecordMetadata().offset()
                    );
                }
            });

        } catch (JsonProcessingException e) {
            log.error(
                    "Failed to serialize OrderCreatedEvent. orderId={}",
                    event.getOrderId(),
                    e
            );
        }
    }
}
