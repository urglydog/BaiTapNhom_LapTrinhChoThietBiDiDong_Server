package iuh.fit.xstore.config;

import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;

public class JwtConfig {
    public static final Key SECRET_KEY =  Keys.hmacShaKeyFor("motChuoiThucSuDaiVaBaoMatChoJWT1234567890".getBytes());
    public static final long EXPIRATION_TIME = 3600000;
}

