package com.ammapickles.address.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddressRequest {

    @NotBlank
    private String name;

    @NotBlank
    private String street;

    @NotBlank
    private String city;

    private String district;

    @NotBlank
    private String state;

    @NotBlank
    private String pincode;

    @NotBlank
    @Pattern(regexp = "^[6-9]\\d{9}$")
    private String mobileNumber;
}
