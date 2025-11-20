package iuh.fit.movieapp.service;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    private final Map<String, OtpData> otpStore = new ConcurrentHashMap<>();
    private final SecureRandom random = new SecureRandom();

    // Tạo OTP + lưu 5 phút
    public String generateOtp(String key) {
        String otp = String.valueOf(100000 + random.nextInt(900000));
        long expireAt = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút

        otpStore.put(key, new OtpData(otp, expireAt));

        return otp;
    }

    // Kiểm tra OTP
    public boolean verifyOtp(String key, String otpInput) {
        OtpData data = otpStore.get(key);

        if (data == null) return false;

        // Hết hạn?
        if (System.currentTimeMillis() > data.expireAt) {
            otpStore.remove(key);
            return false;
        }

        // Đúng?
        boolean ok = data.otp.equals(otpInput);

        if (ok) otpStore.remove(key); // xóa để tránh dùng lại

        return ok;
    }

    private static class OtpData {
        String otp;
        long expireAt;
        public OtpData(String otp, long expireAt) {
            this.otp = otp;
            this.expireAt = expireAt;
        }
    }
}