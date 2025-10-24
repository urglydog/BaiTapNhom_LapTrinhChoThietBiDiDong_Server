package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Cart;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.model.UserType;
import iuh.fit.xstore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;


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
        return userRepo.findByAccountUsername((username))
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
    }

    //tao user
    public User createUser(User user) {
        if (userRepo.existsByAccountUsername(user.getAccount().getUsername())) {
            throw new AppException(ErrorCode.USERNAME_EXISTED);
        }
        if (user.getAccount() != null) {
            user.getAccount().setPassword(
                    passwordEncoder.encode(user.getAccount().getPassword())
            );
        }

        Cart cart = Cart.builder().total(0).build();
        user.setCart(cart);

        user.setUserType(UserType.COPPER);
        user.setPoint(0);

        return userRepo.save(user);
    }


    // Cập nhật user
    public User updateUser(User user) {
        User existedUser = userRepo.findById(user.getId())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        existedUser.setFirstName(user.getFirstName());
        existedUser.setLastName(user.getLastName());
        existedUser.setEmail(user.getEmail());
        existedUser.setPhone(user.getPhone());
        existedUser.setAvatar(user.getAvatar());

        return userRepo.save(existedUser);
    }

    // Xoá user
    public int deleteUser(int id) {
        findById(id);
        userRepo.deleteById(id);
        return id;
    }
}
