package com.ammapickles.notification.controller;

import com.ammapickles.notification.dto.*;
import com.ammapickles.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @PostMapping("/welcome")
    public ResponseEntity<Boolean> sendWelcomeEmail(
            @RequestBody WelcomeEmailRequest request) {

        return ResponseEntity.ok(
                notificationService.sendWelcomeEmail(request));
    }

    @PostMapping("/password-reset")
    public ResponseEntity<Boolean> sendPasswordResetEmail(
            @RequestBody PasswordResetEmailRequest request) {

        return ResponseEntity.ok(
                notificationService.sendPasswordResetEmail(request));
    }

    @PostMapping("/otp")
    public ResponseEntity<Boolean> sendOtpEmail(
            @RequestBody OtpEmailRequest request) {

        return ResponseEntity.ok(
                notificationService.sendOtpEmail(request));
    }

    @PostMapping("/order-confirmation")
    public ResponseEntity<Boolean> sendOrderConfirmationEmail(
            @RequestBody OrderConfirmationRequest request) {

        return ResponseEntity.ok(
                notificationService.sendOrderConfirmationEmail(request));
    }
}
