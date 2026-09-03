package com.ammapickles.address.service;

import com.ammapickles.address.dto.AddressRequest;
import com.ammapickles.address.dto.AddressResponse;

import java.util.List;

public interface AddressService {

    List<AddressResponse> getUserAddresses(Long userId);

    AddressResponse getAddressById(Long addressId, Long userId);

    AddressResponse createAddress(Long userId, AddressRequest request);

    AddressResponse updateAddress(Long addressId, Long userId, AddressRequest request);

    void deleteAddress(Long addressId, Long userId);
}
