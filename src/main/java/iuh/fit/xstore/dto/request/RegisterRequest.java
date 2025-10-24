package iuh.fit.xstore.dto.request;

import iuh.fit.xstore.model.User;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {
    private String username;
    private String password;
    private String email;
    private String fullName;
    private String phone;
    private LocalDate dateOfBirth;
    private User.Gender gender;
}
