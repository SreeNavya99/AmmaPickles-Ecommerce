package com.ammapickles.notification.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WelcomeEmailRequest {

    private String email;
    private String username;
}
