package com.ammapickles.user.controller;

import com.ammapickles.user.dto.UserCreateRequest;
import com.ammapickles.user.dto.UserResponse;
import com.ammapickles.user.dto.UserUpdateRequest;
import com.ammapickles.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping
    public ResponseEntity<UserResponse> createUser(
            @Valid @RequestBody UserCreateRequest request) {

        return ResponseEntity.ok(
                userService.createUser(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                userService.getUserById(id));
    }

    @GetMapping("/email/{email}")
    public ResponseEntity<UserResponse> getUserByEmail(
            @PathVariable String email) {

        return ResponseEntity.ok(
                userService.getUserByEmail(email));
    }

    @GetMapping("/phone/{phoneNumber}")
    public ResponseEntity<UserResponse> getUserByPhone(
            @PathVariable String phoneNumber) {

        return ResponseEntity.ok(
                userService.getUserByPhone(phoneNumber));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UserUpdateRequest request) {

        return ResponseEntity.ok(
                userService.updateUser(id, request));
    }

    @GetMapping("/{id}/exists")
    public ResponseEntity<Boolean> existsById(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                userService.existsById(id));
    }
}
