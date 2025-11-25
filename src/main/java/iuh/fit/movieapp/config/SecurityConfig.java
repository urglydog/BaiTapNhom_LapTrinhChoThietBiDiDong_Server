package iuh.fit.movieapp.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private static final String[] PUBLIC = {
            "/",
            "/api/auth/**",
            "/api/movies/**",
            "/api/cinemas/**",
            "/api/showtimes/**",
            "/api/reviews/**",
            "/api/favourites/**",
            "/api/chat/**",
            "/api/vnpay/return",
            "/api/vnpay/ipn",
            "/api/vnpay/test", // Test endpoint
    };

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.configurationSource(corsConfigurationSource()));
        // .authorizeHttpRequests(auth -> auth
        // .requestMatchers(PUBLIC).permitAll()
        // .requestMatchers("/admin/**").hasRole("ADMIN")
        // .anyRequest().authenticated());

        // Thêm filter JWT trước UsernamePasswordAuthenticationFilter
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Cho phép tất cả các origin (dùng pattern thay vì wildcard khi
        // allowCredentials = true)
        configuration.addAllowedOriginPattern("*");
        configuration.addAllowedMethod("*"); // Cho phép tất cả các HTTP methods
        configuration.addAllowedHeader("*"); // Cho phép tất cả các headers
        // Đặt allowCredentials = false vì mobile app không cần cookies
        // Nếu cần credentials, phải list cụ thể các origins thay vì dùng pattern "*"
        configuration.setAllowCredentials(false);
        configuration.setMaxAge(3600L); // Cache preflight request trong 1 giờ

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
