package com.ammapickles.auth.security;

import com.ammapickles.auth.entity.UserCredential;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

@Service
public class AuthUserDetailsService implements UserDetailsService {

    private final UserCredentialRepository credentialRepository;

    public AuthUserDetailsService(
            UserCredentialRepository credentialRepository) {
        this.credentialRepository = credentialRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email)
            throws UsernameNotFoundException {

        UserCredential credential =
            credentialRepository.findByEmail(email)
                .orElseThrow(() ->
                    new UsernameNotFoundException(
                        "User not found: " + email));

        return org.springframework.security.core.userdetails.User
            .withUsername(credential.getEmail())
            .password(credential.getPassword())
            .authorities(
                credential.getRoles().stream()
                    .map(SimpleGrantedAuthority::new)
                    .toList()
            )
            .disabled(!credential.isEnabled())
            .build();
    }
}
