package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.request.*;
import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Role;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.UserRepository;
import iuh.fit.movieapp.security.UserDetail;
import iuh.fit.movieapp.service.MailService;
import iuh.fit.movieapp.service.OtpService;
import iuh.fit.movieapp.util.JwtUtil;
import jakarta.mail.MessagingException;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private OtpService otpService;
    @Autowired
    private MailService mailService;

    @PostMapping("/login")
    public ApiResponse<?> login(@RequestBody LoginRequest request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsername(),
                            request.getPassword()));
            SecurityContextHolder.getContext().setAuthentication(authentication);

            UserDetail userDetail = (UserDetail) authentication.getPrincipal();
            String token = jwtUtil.generateToken(userDetail);

            User user = userRepository.findByUsername(request.getUsername())
                    .orElseThrow(() -> new RuntimeException("User not found"));

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", user);

            return new ApiResponse<>(SuccessCode.LOGIN_SUCCESSFULLY, data);

        } catch (BadCredentialsException e) {
            return new ApiResponse<>(ErrorCode.INCORRECT_USERNAME_OR_PASSWORD);
        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.USER_NOT_FOUND);
        }
    }

    // ================= GOOGLE LOGIN =================
    @PostMapping("/google-login")
    public ApiResponse<?> googleLogin(@RequestBody GoogleLoginRequest request) {
        try {
            // Check if user already exists with this Google ID
            User existingUser = userRepository.findByGoogleId(request.getGoogleId()).orElse(null);

            if (existingUser != null) {
                // User exists, generate token and return
                UserDetail userDetail = new UserDetail(existingUser);
                String token = jwtUtil.generateToken(userDetail);

                Map<String, Object> data = new HashMap<>();
                data.put("token", token);
                data.put("user", existingUser);

                return new ApiResponse<>(SuccessCode.LOGIN_SUCCESSFULLY, data);
            }

            // Check if email already exists (user registered with email before)
            User emailUser = userRepository.findByEmail(request.getEmail()).orElse(null);
            if (emailUser != null) {
                // Link Google account to existing user
                emailUser.setGoogleId(request.getGoogleId());
                emailUser.setAvatarUrl(request.getAvatarUrl());
                userRepository.save(emailUser);

                UserDetail userDetail = new UserDetail(emailUser);
                String token = jwtUtil.generateToken(userDetail);

                Map<String, Object> data = new HashMap<>();
                data.put("token", token);
                data.put("user", emailUser);

                return new ApiResponse<>(SuccessCode.LOGIN_SUCCESSFULLY, data);
            }

            // Create new user
            String username = generateUniqueUsername(request.getEmail());
            User newUser = User.builder()
                    .username(username)
                    .email(request.getEmail())
                    .password(passwordEncoder.encode("GOOGLE_USER_" + request.getGoogleId())) // Random password for Google users
                    .fullName(request.getFullName())
                    .googleId(request.getGoogleId())
                    .avatarUrl(request.getAvatarUrl())
                    .role(Role.CUSTOMER)
                    .active(true)
                    .build();

            userRepository.save(newUser);

            UserDetail userDetail = new UserDetail(newUser);
            String token = jwtUtil.generateToken(userDetail);

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", newUser);

            return new ApiResponse<>(SuccessCode.LOGIN_SUCCESSFULLY, data);

        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.UNKNOWN_ERROR);
        }
    }

    // ================= REGISTER =================
    @PostMapping("/register")
    public ApiResponse<?> register(@RequestBody RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            return new ApiResponse<>(ErrorCode.USERNAME_EXISTED);
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            return new ApiResponse<>(ErrorCode.EMAIL_EXISTED);
        }

        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .phone(request.getPhone())
                .dateOfBirth(request.getDateOfBirth())
                .gender(request.getGender())
                .role(Role.CUSTOMER)
                .active(true)
                .build();

        userRepository.save(user);

        return new ApiResponse<>(SuccessCode.REGISTER_SUCCESSFULLY, user);
    }

    // ================= RESET PASSWORD =================
    @PostMapping("/reset-password")
    public ApiResponse<?> resetPassword(@RequestBody ResetPasswordRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElse(null);

        if (user == null) {
            return new ApiResponse<>(ErrorCode.USER_NOT_FOUND);
        }

        // Mã hóa mật khẩu mới
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        return new ApiResponse<>(SuccessCode.RESET_PASSWORD_SUCCESSFULLY, user);
    }

    // ================= GET CURRENT USER =================
    @GetMapping("/me")
    public ApiResponse<?> getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || authentication.getName() == null) {
                return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
            }

            String username = authentication.getName();
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, user);
        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
    }

    // ================= LOGOUT =================
    @PostMapping("/logout")
    public ApiResponse<?> logout() {
        // JWT is stateless, so logout is handled client-side by removing the token
        // This endpoint is for consistency with frontend expectations
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, "Logged out successfully");
    }

    // ================= CHANGE PASSWORD =================
    @PutMapping("/change-password")
    public ApiResponse<?> changePassword(@RequestBody ChangePasswordRequest request) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || authentication.getName() == null) {
                return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
            }

            String username = authentication.getName();
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            // Verify old password
            if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
                return new ApiResponse<>(ErrorCode.INVALID_PASSWORD);
            }

            // Update password
            user.setPassword(passwordEncoder.encode(request.getNewPassword()));
            userRepository.save(user);

            return new ApiResponse<>(SuccessCode.RESET_PASSWORD_SUCCESSFULLY, user);
        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
    }

    // ================= INIT ADMIN (Tạm thời - chỉ dùng để setup) =================
    @PostMapping("/init-admin")
    public ApiResponse<?> initAdmin() {
        try {
            // Kiểm tra xem admin đã tồn tại chưa
            User existingAdmin = userRepository.findByUsername("admin").orElse(null);

            if (existingAdmin != null) {
                // Nếu đã tồn tại, reset password về "password"
                existingAdmin.setPassword(passwordEncoder.encode("password"));
                existingAdmin.setActive(true);
                userRepository.save(existingAdmin);
                return new ApiResponse<>(SuccessCode.RESET_PASSWORD_SUCCESSFULLY,
                        "Admin user đã tồn tại. Đã reset password về 'password'");
            } else {
                // Nếu chưa tồn tại, tạo mới
                User admin = User.builder()
                        .username("admin")
                        .email("admin@movieticket.com")
                        .password(passwordEncoder.encode("password"))
                        .fullName("Admin System")
                        .phone("0123456789")
                        .role(Role.ADMIN)
                        .active(true)
                        .build();
                userRepository.save(admin);
                return new ApiResponse<>(SuccessCode.USER_CREATED,
                        "Đã tạo admin user mới. Username: admin, Password: password");
            }
        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.UNKNOWN_ERROR);
        }
    }

    // ================= Get OTP ============
    @PostMapping("/send-otp")
    public ApiResponse<?> sendOtp(@RequestParam String email, @RequestParam(defaultValue = "REGISTER") String type) throws MessagingException {
        if ("REGISTER".equals(type)) {
            // For registration, email should NOT exist
            if (userRepository.existsByEmail(email)) {
                return new ApiResponse<>(ErrorCode.EMAIL_EXISTED);
            }
        } else if ("RESET_PASSWORD".equals(type)) {
            // For password reset, email MUST exist
            if (!userRepository.existsByEmail(email)) {
                return new ApiResponse<>(ErrorCode.USER_NOT_FOUND);
            }
        }

        String otp = otpService.generateOtp(email);
        mailService.sendOtpMail(email);
        return new ApiResponse<>(SuccessCode.OTP_SENT, email);
    }

    // ================= Send OTP for Registration ============
    @PostMapping("/send-otp-register")
    public ApiResponse<?> sendOtpForRegister(@RequestParam String email) throws MessagingException {
        // For registration, email should NOT exist
        if (userRepository.existsByEmail(email)) {
            return new ApiResponse<>(ErrorCode.EMAIL_EXISTED);
        }

        String otp = otpService.generateOtp(email);
        mailService.sendOtpMail(email);
        return new ApiResponse<>(SuccessCode.OTP_SENT, email);
    }

    // ================= Send OTP for Password Reset ============
    @PostMapping("/send-otp-reset")
    public ApiResponse<?> sendOtpForReset(@RequestParam String email) throws MessagingException {
        // For password reset, email MUST exist
        if (!userRepository.existsByEmail(email)) {
            return new ApiResponse<>(ErrorCode.USER_NOT_FOUND);
        }

        String otp = otpService.generateOtp(email);
        mailService.sendOtpMail(email);
        return new ApiResponse<>(SuccessCode.OTP_SENT, email);
    }

    // ================= Verify OTP ============
    @PostMapping("/verify-otp")
    public ApiResponse<?> verifyOtp(@RequestParam String email, @RequestParam String otp) {
        boolean isValid = otpService.verifyOtp(email, otp);
        if (isValid) {
            return new ApiResponse<>(SuccessCode.OTP_VERIFIED, "OTP verified successfully");
        } else {
            return new ApiResponse<>(ErrorCode.INVALID_OTP);
        }
    }

    // ================= Helper method =================
    private String generateUniqueUsername(String email) {
        String baseUsername = email.substring(0, email.indexOf('@'));
        String username = baseUsername;
        int counter = 1;

        while (userRepository.existsByUsername(username)) {
            username = baseUsername + counter;
            counter++;
        }

        return username;
    }
}
