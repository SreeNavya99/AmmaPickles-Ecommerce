package com.ammapickles.order.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "address-service", url = "${address.service.url}")
public interface AddressClient {

    @GetMapping("/api/addresses/{addressId}/user/{userId}")
    AddressResponse getAddress(
            @PathVariable Long addressId,
            @PathVariable Long userId
    );

    record AddressResponse(
            Long id,
            Long userId,
            String name,
            String street,
            String city,
            String district,
            String state,
            String pincode,
            String mobileNumber
    ) {}
}
