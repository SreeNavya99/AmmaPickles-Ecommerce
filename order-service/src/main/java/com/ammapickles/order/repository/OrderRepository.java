package com.ammapickles.order.repository;

import com.ammapickles.order.entity.Order;
import com.ammapickles.order.entity.OrderStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByUserIdOrderByOrderDateDesc(Long userId);

    long countByUserId(Long userId);

    Page<Order> findByStatus(OrderStatus status, Pageable pageable);
}
