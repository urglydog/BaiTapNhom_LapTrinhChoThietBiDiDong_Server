package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Role;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;

    public List<User> findAll() {
        return userRepo.findAll();
    }

    public User findById(int id) {
        return userRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
    }

    public User findByUsername(String username) {
        return userRepo.findByUsername(username)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
    }

    public User findByEmail(String email) {
        return userRepo.findByEmail(email)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
    }

    public User createUser(User user) {
        if (userRepo.existsByUsername(user.getUsername())) {
            throw new AppException(ErrorCode.USERNAME_EXISTED);
        }
        if (userRepo.existsByEmail(user.getEmail())) {
            throw new AppException(ErrorCode.EMAIL_EXISTED);
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        if (user.getRole() == null) {
            user.setRole(Role.CUSTOMER);
        }

        return userRepo.save(user);
    }

    public User updateUser(User user) {
        User existedUser = userRepo.findById(user.getId())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        existedUser.setFullName(user.getFullName());
        existedUser.setEmail(user.getEmail());
        existedUser.setPhone(user.getPhone());
        existedUser.setDateOfBirth(user.getDateOfBirth());
        existedUser.setGender(user.getGender());
        existedUser.setAvatarUrl(user.getAvatarUrl());

        return userRepo.save(existedUser);
    }

    public int deleteUser(int id) {
        findById(id);
        userRepo.deleteById(id);
        return id;
    }

    public boolean existsByUsername(String username) {
        return userRepo.existsByUsername(username);
    }

    public boolean existsByEmail(String email) {
        return userRepo.existsByEmail(email);
    }
}
