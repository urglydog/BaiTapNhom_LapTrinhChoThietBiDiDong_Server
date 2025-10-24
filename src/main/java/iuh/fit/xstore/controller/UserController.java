package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@AllArgsConstructor
public class UserController {
    private final UserService userService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<List<User>> getUsers() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.findAll());
    }

    @GetMapping("/{id}")
    public ApiResponse<User> getUser(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.findById(id));
    }

    @GetMapping("/username/{username}")
    public ApiResponse<User> getUserByUsername(@PathVariable String username) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.findByUsername(username));
    }

    @GetMapping("/email/{email}")
    public ApiResponse<User> getUserByEmail(@PathVariable String email) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.findByEmail(email));
    }

    @PostMapping
    public ApiResponse<User> createUser(@RequestBody User user) {
        User createdUser = userService.createUser(user);
        return new ApiResponse<>(SuccessCode.USER_CREATED, createdUser);
    }

    @PutMapping("/{id}")
    public ApiResponse<User> updateUser(@PathVariable int id, @RequestBody User user) {
        user.setId(id);
        User updatedUser = userService.updateUser(user);
        return new ApiResponse<>(SuccessCode.USER_UPDATED, updatedUser);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Integer> deleteUser(@PathVariable int id) {
        userService.deleteUser(id);
        return new ApiResponse<>(SuccessCode.USER_DELETED, id);
    }

    @GetMapping("/check-username/{username}")
    public ApiResponse<Boolean> checkUsername(@PathVariable String username) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.existsByUsername(username));
    }

    @GetMapping("/check-email/{email}")
    public ApiResponse<Boolean> checkEmail(@PathVariable String email) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, userService.existsByEmail(email));
    }
}
