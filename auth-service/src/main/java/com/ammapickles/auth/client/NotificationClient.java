package com.ammapickles.auth.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(
    name = "notification-service",
    url = "${notification.service.url}"
)
public interface NotificationClient {

    @PostMapping("/api/notifications/welcome")
    void sendWelcomeEmail(@RequestBody WelcomeRequest request);

    @PostMapping("/api/notifications/password-reset")
    void sendPasswordResetEmail(@RequestBody PasswordResetRequest request);

    @PostMapping("/api/notifications/otp")
    void sendOtpEmail(@RequestBody OtpRequest request);

    record WelcomeRequest(
        String email,
        String username
    ) {}

    record PasswordResetRequest(
        String email,
        String username,
        String resetLink
    ) {}

    record OtpRequest(
        String email,
        String username,
        String otp
    ) {}
}
