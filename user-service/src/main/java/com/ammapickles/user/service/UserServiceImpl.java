package com.ammapickles.user.service;

import com.ammapickles.user.dto.UserCreateRequest;
import com.ammapickles.user.dto.UserResponse;
import com.ammapickles.user.dto.UserUpdateRequest;
import com.ammapickles.user.entity.User;
import com.ammapickles.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    @Transactional
    public UserResponse createUser(UserCreateRequest request) {

        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalStateException(
                    "User already exists with email: " + request.getEmail());
        }

        if (request.getPhoneNumber() != null
                && userRepository.findByPhoneNumber(request.getPhoneNumber()).isPresent()) {
            throw new IllegalStateException(
                    "User already exists with phone number: "
                            + request.getPhoneNumber());
        }

        User user = User.builder()
                .email(request.getEmail())
                .username(request.getUsername())
                .phoneNumber(request.getPhoneNumber())
                .enabled(true)
                .build();

        return mapToResponse(userRepository.save(user));
    }

    @Override
    public UserResponse getUserById(Long id) {
        return userRepository.findById(id)
                .map(this::mapToResponse)
                .orElseThrow(() ->
                        new RuntimeException("User not found: " + id));
    }

    @Override
    public UserResponse getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(this::mapToResponse)
                .orElseThrow(() ->
                        new RuntimeException("User not found: " + email));
    }

    @Override
    public UserResponse getUserByPhone(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber)
                .map(this::mapToResponse)
                .orElseThrow(() ->
                        new RuntimeException(
                                "User not found: " + phoneNumber));
    }

    @Override
    @Transactional
    public UserResponse updateUser(
            Long id,
            UserUpdateRequest request) {

        User user = userRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("User not found: " + id));

        if (request.getUsername() != null) {
            user.setUsername(request.getUsername());
        }

        if (request.getPhoneNumber() != null) {
            user.setPhoneNumber(request.getPhoneNumber());
        }

        return mapToResponse(userRepository.save(user));
    }

    @Override
    public boolean existsById(Long id) {
        return userRepository.existsById(id);
    }

    private UserResponse mapToResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .username(user.getUsername())
                .phoneNumber(user.getPhoneNumber())
                .enabled(user.isEnabled())
                .createdAt(user.getCreatedAt())
                .build();
    }
}
