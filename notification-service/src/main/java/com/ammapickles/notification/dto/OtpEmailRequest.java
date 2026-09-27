package com.ammapickles.notification.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OtpEmailRequest {

    private String email;
    private String otp;
}
