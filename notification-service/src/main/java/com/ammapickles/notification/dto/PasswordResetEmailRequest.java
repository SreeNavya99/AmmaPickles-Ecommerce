package com.ammapickles.notification.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasswordResetEmailRequest {

    private String email;
    private String resetLink;
}
