package com.ammapickles.user.service;

import com.ammapickles.user.dto.UserCreateRequest;
import com.ammapickles.user.dto.UserResponse;
import com.ammapickles.user.dto.UserUpdateRequest;

public interface UserService {

    UserResponse createUser(UserCreateRequest request);

    UserResponse getUserById(Long id);

    UserResponse getUserByEmail(String email);

    UserResponse getUserByPhone(String phoneNumber);

    UserResponse updateUser(Long id, UserUpdateRequest request);

    boolean existsById(Long id);
}
