package iuh.fit.xstore.dto.request;

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
    private String email; // có thể thêm các trường khác như fullname nếu cần
    private String firstName;
    private String lastName;
    private LocalDate dob;
}
