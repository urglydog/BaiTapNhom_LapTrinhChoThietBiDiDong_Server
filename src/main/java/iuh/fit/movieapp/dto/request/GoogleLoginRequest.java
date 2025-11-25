package iuh.fit.movieapp.dto.request;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GoogleLoginRequest {
    private String googleId;
    private String email;
    private String fullName;
    private String avatarUrl;
}