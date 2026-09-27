package com.ammapickles.auth.service;

import com.ammapickles.auth.dto.*;

public interface AuthService {

    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    void forgotPassword(String email);

    void resetPasswordWithToken(
        String token,
        ResetPasswordRequest request
    );
}
