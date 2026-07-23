package com.insurance.framework.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Spring Security配置
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final UserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter,
                          UserDetailsService userDetailsService,
                          PasswordEncoder passwordEncoder) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/swagger-ui/**",
                                "/doc.html",
                                "/webjars/**",
                                "/v3/api-docs/**",
                                "/api/health",
                                "/health",
                                "/api/v1/auth/login",
                                "/v1/auth/login",
                                "/api/v1/auth/register",
                                "/v1/auth/register",
                                "/api/v1/auth/check-username",
                                "/v1/auth/check-username",
                                "/api/v1/auth/captcha",
                                "/v1/auth/captcha",
                                "/api/v1/auth/send-code",
                                "/v1/auth/send-code",
                                "/api/v1/user/info",
                                "/v1/user/info",
                                "/api/v1/product/**",
                                "/v1/product/**",
                                "/api/v1/company/**",
                                "/v1/company/**",
                                "/api/v1/card-template/**",
                                "/v1/card-template/**",
                                "/api/v1/vip/**",
                                "/v1/vip/**",
                                "/api/v1/compare/**",
                                "/v1/compare/**",
                                "/api/v1/calculate/**",
                                "/v1/calculate/**",
                                "/api/wechat/**",
                                "/wechat/**",
                                "/api/v1/admin/auth/login",
                                "/v1/admin/auth/login",
                                "/api/v1/admin/auth/info",
                                "/v1/admin/auth/info",
                                "/api/v1/admin/auth/logout",
                                "/v1/admin/auth/logout",
                                "/api/v1/admin/auth/refresh",
                                "/v1/admin/auth/refresh",
                                "/api/v1/admin/dashboard/**",
                                "/v1/admin/dashboard/**",
                                "/api/v1/admin/product/**",
                                "/v1/admin/product/**",
                                "/api/v1/admin/company/**",
                                "/v1/admin/company/**",
                                "/api/v1/admin/card-template/**",
                                "/v1/admin/card-template/**",
                                "/api/v1/admin/vip/**",
                                "/v1/admin/vip/**",
                                "/api/v1/admin/system/**",
                                "/v1/admin/system/**",
                                "/admin/health"
                        ).permitAll()
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return new ProviderManager(provider);
    }
}
