package com.ammapickles.notification.service;

import com.ammapickles.notification.dto.*;

public interface NotificationService {

    boolean sendWelcomeEmail(WelcomeEmailRequest request);

    boolean sendPasswordResetEmail(PasswordResetEmailRequest request);

    boolean sendOtpEmail(OtpEmailRequest request);

    boolean sendOrderConfirmationEmail(OrderConfirmationRequest request);
}
