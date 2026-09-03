package com.ammapickles.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserCreateRequest {

    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String username;

    @Pattern(regexp = "^[6-9]\\d{9}$")
    private String phoneNumber;
}
