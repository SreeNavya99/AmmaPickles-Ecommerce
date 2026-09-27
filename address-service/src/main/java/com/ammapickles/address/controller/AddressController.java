package com.ammapickles.address.controller;

import com.ammapickles.address.dto.AddressRequest;
import com.ammapickles.address.dto.AddressResponse;
import com.ammapickles.address.service.AddressService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/addresses")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService addressService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<AddressResponse>> getUserAddresses(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                addressService.getUserAddresses(userId));
    }

    @GetMapping("/{addressId}/user/{userId}")
    public ResponseEntity<AddressResponse> getAddressById(
            @PathVariable Long addressId,
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                addressService.getAddressById(addressId, userId));
    }

    @PostMapping("/user/{userId}")
    public ResponseEntity<AddressResponse> createAddress(
            @PathVariable Long userId,
            @Valid @RequestBody AddressRequest request) {

        return ResponseEntity.ok(
                addressService.createAddress(userId, request));
    }

    @PutMapping("/{addressId}/user/{userId}")
    public ResponseEntity<AddressResponse> updateAddress(
            @PathVariable Long addressId,
            @PathVariable Long userId,
            @Valid @RequestBody AddressRequest request) {

        return ResponseEntity.ok(
                addressService.updateAddress(
                        addressId, userId, request));
    }

    @DeleteMapping("/{addressId}/user/{userId}")
    public ResponseEntity<Void> deleteAddress(
            @PathVariable Long addressId,
            @PathVariable Long userId) {

        addressService.deleteAddress(addressId, userId);

        return ResponseEntity.noContent().build();
    }
}
