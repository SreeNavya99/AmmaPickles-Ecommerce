package com.ammapickles.address.service;

import com.ammapickles.address.client.UserClient;
import com.ammapickles.address.dto.AddressRequest;
import com.ammapickles.address.dto.AddressResponse;
import com.ammapickles.address.entity.Address;
import com.ammapickles.address.repository.AddressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressServiceImpl implements AddressService {

    private static final int MAX_ADDRESSES_PER_USER = 5;

    private final AddressRepository addressRepository;
    private final UserClient userClient;

    @Override
    public List<AddressResponse> getUserAddresses(Long userId) {
        validateUser(userId);

        return addressRepository.findByUserId(userId)
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    @Override
    public AddressResponse getAddressById(Long addressId, Long userId) {
        Address address = addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() ->
                        new RuntimeException("Address not found: " + addressId));

        return mapToResponse(address);
    }

    @Override
    @Transactional
    public AddressResponse createAddress(Long userId, AddressRequest request) {

        validateUser(userId);

        long addressCount = addressRepository.findByUserId(userId).size();

        if (addressCount >= MAX_ADDRESSES_PER_USER) {
            throw new IllegalStateException(
                    "Maximum of " + MAX_ADDRESSES_PER_USER +
                    " addresses allowed per user");
        }

        Address address = Address.builder()
                .userId(userId)
                .name(request.getName())
                .street(request.getStreet())
                .city(request.getCity())
                .district(request.getDistrict())
                .state(request.getState())
                .pincode(request.getPincode())
                .mobileNumber(request.getMobileNumber())
                .build();

        return mapToResponse(addressRepository.save(address));
    }

    @Override
    @Transactional
    public AddressResponse updateAddress(
            Long addressId,
            Long userId,
            AddressRequest request) {

        Address address = addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() ->
                        new RuntimeException("Address not found: " + addressId));

        address.setName(request.getName());
        address.setStreet(request.getStreet());
        address.setCity(request.getCity());
        address.setDistrict(request.getDistrict());
        address.setState(request.getState());
        address.setPincode(request.getPincode());
        address.setMobileNumber(request.getMobileNumber());

        return mapToResponse(addressRepository.save(address));
    }

    @Override
    @Transactional
    public void deleteAddress(Long addressId, Long userId) {

        Address address = addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() ->
                        new RuntimeException("Address not found: " + addressId));

        addressRepository.delete(address);
    }

    private void validateUser(Long userId) {
        userClient.getUserById(userId);
    }

    private AddressResponse mapToResponse(Address address) {
        return AddressResponse.builder()
                .id(address.getId())
                .userId(address.getUserId())
                .name(address.getName())
                .street(address.getStreet())
                .city(address.getCity())
                .district(address.getDistrict())
                .state(address.getState())
                .pincode(address.getPincode())
                .mobileNumber(address.getMobileNumber())
                .build();
    }
}
