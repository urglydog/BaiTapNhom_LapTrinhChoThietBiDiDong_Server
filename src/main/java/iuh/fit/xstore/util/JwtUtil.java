package iuh.fit.xstore.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.ExpiredJwtException;
import iuh.fit.xstore.config.JwtConfig;
import iuh.fit.xstore.security.UserDetail;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtUtil {

    // Tạo token
    public static String generateToken(UserDetail user) {
        return Jwts.builder()
                .setSubject(user.getUsername())
                .claim("role", "ROLE_" + user.getRole())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + JwtConfig.EXPIRATION_TIME))
                .signWith(JwtConfig.SECRET_KEY)
                .compact();
    }

    // Lấy thông tin username từ token
    public String getUsername(String token) {
        return getClaims(token).getSubject();
    }

    // Lấy role từ token
    public String getRole(String token) {
        return getClaims(token).get("role", String.class);
    }

    // Kiểm tra token còn hiệu lực
    public boolean isTokenValid(String token) {
        try {
            getClaims(token);
            return true;
        } catch (ExpiredJwtException e) {
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    private Claims getClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(JwtConfig.SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
