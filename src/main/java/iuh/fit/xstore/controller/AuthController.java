package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.request.LoginRequest;
import iuh.fit.xstore.dto.request.RegisterRequest;
import iuh.fit.xstore.dto.request.ResetPasswordRequest;
import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Role;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.repository.UserRepository;
import iuh.fit.xstore.security.UserDetail;
import iuh.fit.xstore.util.JwtUtil;
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
                .isActive(true)
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
}
