package com.ammapickles.auth.service;

import com.ammapickles.auth.client.NotificationClient;
import com.ammapickles.auth.client.UserClient;
import com.ammapickles.auth.dto.*;
import com.ammapickles.auth.entity.PasswordResetToken;
import com.ammapickles.auth.entity.UserCredential;
import com.ammapickles.auth.repository.PasswordResetTokenRepository;
import com.ammapickles.auth.security.JwtUtil;
import com.ammapickles.auth.security.UserCredentialRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserCredentialRepository credentialRepository;
    private final PasswordResetTokenRepository resetTokenRepository;
    private final UserClient userClient;
    private final NotificationClient notificationClient;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {

        if (credentialRepository
                .findByEmail(request.getEmail())
                .isPresent()) {

            throw new IllegalArgumentException(
                    "Email already registered");
        }

        // Create the user profile in User Service first.
        UserClient.UserResponse user =
                userClient.createUser(
                        new UserClient.CreateUserRequest(
                                request.getEmail(),
                                request.getUsername(),
                                request.getPhoneNumber()
                        )
                );

        UserCredential credential = UserCredential.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .enabled(true)
                .roles(Set.of("ROLE_CUSTOMER"))
                .build();

        credentialRepository.save(credential);

        try {
            notificationClient.sendWelcomeEmail(
                    new NotificationClient.WelcomeRequest(
                            request.getEmail(),
                            request.getUsername()
                    )
            );
        } catch (Exception e) {
            log.warn(
                    "Welcome email could not be sent to {}",
                    request.getEmail(),
                    e
            );
        }

        return new AuthResponse(
                null,
                user.email(),
                user.username(),
                "ROLE_CUSTOMER",
                "Registered successfully"
        );
    }

    @Override
    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getIdentifier(),
                        request.getPassword()
                )
        );

        UserClient.UserResponse user;

        if (request.getIdentifier().contains("@")) {
            user = userClient.getUserByEmail(
                    request.getIdentifier()
            );
        } else {
            user = userClient.getUserByPhoneNumber(
                    request.getIdentifier()
            );
        }

        UserCredential credential =
                credentialRepository.findByEmail(user.email())
                        .orElseThrow(() ->
                                new IllegalArgumentException(
                                        "Credentials not found"));

        String role = credential.getRoles()
                .stream()
                .findFirst()
                .orElse("ROLE_CUSTOMER");

        String token = jwtUtil.generateToken(user.email());

        return new AuthResponse(
                token,
                user.email(),
                user.username(),
                role,
                "Login successful"
        );
    }

    @Override
    @Transactional
    public void forgotPassword(String email) {

        UserClient.UserResponse user =
                userClient.getUserByEmail(email);

        resetTokenRepository.deleteByUserId(user.id());

        String token = UUID.randomUUID().toString();

        PasswordResetToken resetToken =
                PasswordResetToken.builder()
                        .token(token)
                        .userId(user.id())
                        .expiresAt(
                                LocalDateTime.now().plusHours(1)
                        )
                        .build();

        resetTokenRepository.save(resetToken);

        String resetLink =
                baseUrl + "/reset-password?token=" + token;

        notificationClient.sendPasswordResetEmail(
                new NotificationClient.PasswordResetRequest(
                        user.email(),
                        user.username(),
                        resetLink
                )
        );
    }

    @Override
    @Transactional
    public void resetPasswordWithToken(
            String token,
            ResetPasswordRequest request) {

        PasswordResetToken resetToken =
                resetTokenRepository.findByToken(token)
                        .orElseThrow(() ->
                                new IllegalArgumentException(
                                        "Invalid or expired reset link"));

        if (resetToken.isExpired()) {
            resetTokenRepository.delete(resetToken);

            throw new IllegalArgumentException(
                    "Reset link has expired");
        }

        UserClient.UserResponse user =
                userClient.getUserById(
                        resetToken.getUserId()
                );

        UserCredential credential =
                credentialRepository.findByEmail(user.email())
                        .orElseThrow(() ->
                                new IllegalArgumentException(
                                        "Credentials not found"));

        credential.setPassword(
                passwordEncoder.encode(
                        request.getNewPassword()
                )
        );

        credentialRepository.save(credential);
        resetTokenRepository.delete(resetToken);
    }
}
