package com.ammapickles.user.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse {

    private Long id;
    private String email;
    private String username;
    private String phoneNumber;
    private boolean enabled;
    private LocalDateTime createdAt;
}
