package com.ammapickles.auth.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(
        name = "user-service",
        url = "${user.service.url}"
)
public interface UserClient {

    @PostMapping("/api/users")
    UserResponse createUser(
            @RequestBody CreateUserRequest request);

    @GetMapping("/api/users/{id}")
    UserResponse getUserById(
            @PathVariable Long id);

    @GetMapping("/api/users/email/{email}")
    UserResponse getUserByEmail(
            @PathVariable String email);

    @GetMapping("/api/users/phone/{phoneNumber}")
    UserResponse getUserByPhoneNumber(
            @PathVariable String phoneNumber);

    record CreateUserRequest(
            String email,
            String username,
            String phoneNumber
    ) {}

    record UserResponse(
            Long id,
            String email,
            String username,
            String phoneNumber,
            boolean enabled
    ) {}
}
