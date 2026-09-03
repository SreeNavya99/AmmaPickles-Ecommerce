package com.ammapickles.notification.service;

import com.ammapickles.notification.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Slf4j
@Service
public class NotificationServiceImpl implements NotificationService {

    private final String brevoApiKey;
    private final String mailFrom;
    private final String senderName;
    private final HttpClient httpClient;

    public NotificationServiceImpl(
            @Value("${BREVO_API_KEY:}") String brevoApiKey,
            @Value("${app.mail.from}") String mailFrom,
            @Value("${app.mail.sender-name:Amma Pickles}") String senderName) {

        this.brevoApiKey = brevoApiKey;
        this.mailFrom = mailFrom;
        this.senderName = senderName;

        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(java.time.Duration.ofSeconds(5))
                .build();
    }

    @Override
    public boolean sendWelcomeEmail(WelcomeEmailRequest request) {

        String html = """
                <html>
                <body>
                    <h2>Welcome to Amma Pickles!</h2>
                    <p>Hello %s,</p>
                    <p>Your account has been successfully created.</p>
                    <p>Thank you for choosing Amma Pickles.</p>
                </body>
                </html>
                """.formatted(request.getUsername());

        return sendEmail(
                request.getEmail(),
                "Welcome to Amma Pickles",
                html
        );
    }

    @Override
    public boolean sendPasswordResetEmail(
            PasswordResetEmailRequest request) {

        String html = """
                <html>
                <body>
                    <h2>Password Reset</h2>
                    <p>We received a request to reset your password.</p>
                    <p>
                        <a href="%s">Reset Password</a>
                    </p>
                    <p>This link will expire in 1 hour.</p>
                </body>
                </html>
                """.formatted(request.getResetLink());

        return sendEmail(
                request.getEmail(),
                "Reset Your Amma Pickles Password",
                html
        );
    }

    @Override
    public boolean sendOtpEmail(OtpEmailRequest request) {

        String html = """
                <html>
                <body>
                    <h2>Amma Pickles Verification Code</h2>
                    <p>Your OTP is:</p>
                    <h1>%s</h1>
                    <p>This OTP is valid for a limited time.</p>
                </body>
                </html>
                """.formatted(request.getOtp());

        return sendEmail(
                request.getEmail(),
                "Your Amma Pickles OTP",
                html
        );
    }

    @Override
    public boolean sendOrderConfirmationEmail(
            OrderConfirmationRequest request) {

        StringBuilder itemsHtml = new StringBuilder();

        if (request.getItems() != null) {
            for (OrderConfirmationRequest.OrderItemRequest item :
                    request.getItems()) {

                itemsHtml.append("""
                        <li>%s × %d — ₹%s</li>
                        """.formatted(
                        item.getProductName(),
                        item.getQuantity(),
                        item.getPrice()
                ));
            }
        }

        String html = """
                <html>
                <body>
                    <h2>Order Confirmed!</h2>

                    <p>Thank you for your order.</p>

                    <p><strong>Order ID:</strong> %d</p>

                    <h3>Items</h3>
                    <ul>
                        %s
                    </ul>

                    <p>Subtotal: ₹%s</p>
                    <p>Delivery: ₹%s</p>
                    <p><strong>Total: ₹%s</strong></p>

                    <p>Thank you for shopping with Amma Pickles.</p>
                </body>
                </html>
                """.formatted(
                        request.getOrderId(),
                        itemsHtml,
                        request.getTotalAmount(),
                        request.getDeliveryCharge(),
                        request.getGrandTotal()
                );

        return sendEmail(
                request.getEmail(),
                "Order Confirmation - Amma Pickles",
                html
        );
    }

    private boolean sendEmail(
            String recipient,
            String subject,
            String htmlContent) {

        if (brevoApiKey == null || brevoApiKey.isBlank()) {
            log.warn("BREVO_API_KEY is not configured");
            return false;
        }

        String json = """
                {
                  "sender": {
                    "name": "%s",
                    "email": "%s"
                  },
                  "to": [
                    {
                      "email": "%s"
                    }
                  ],
                  "subject": "%s",
                  "htmlContent": "%s"
                }
                """.formatted(
                escapeJson(senderName),
                escapeJson(mailFrom),
                escapeJson(recipient),
                escapeJson(subject),
                escapeJson(htmlContent)
        );

        try {

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(
                            "https://api.brevo.com/v3/smtp/email"))
                    .header("accept", "application/json")
                    .header("api-key", brevoApiKey)
                    .header("content-type", "application/json")
                    .timeout(java.time.Duration.ofSeconds(5))
                    .POST(HttpRequest.BodyPublishers.ofString(json))
                    .build();

            HttpResponse<String> response =
                    httpClient.send(
                            request,
                            HttpResponse.BodyHandlers.ofString()
                    );

            if (response.statusCode() == 201) {
                log.info(
                        "Email sent successfully to {}",
                        recipient);
                return true;
            }

            log.error(
                    "Brevo email failed. Status: {}, Response: {}",
                    response.statusCode(),
                    response.body());

        } catch (Exception e) {
            log.error(
                    "Failed to send email to {}",
                    recipient,
                    e);
        }

        return false;
    }

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
