package com.ammapickles.address.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddressResponse {

    private Long id;
    private Long userId;
    private String name;
    private String street;
    private String city;
    private String district;
    private String state;
    private String pincode;
    private String mobileNumber;
}
