package iuh.fit.movieapp.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.AllArgsConstructor;
import org.springframework.boot.autoconfigure.mail.MailProperties;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class MailService {
    private final JavaMailSender mailSender;
    private final OtpService otpService;

    public void sendOtpMail(String email) throws MessagingException {
        // 1. Tạo OTP và lưu trong OtpService
        String otp = otpService.generateOtp(email);

        // 2. Tạo MimeMessage
        MimeMessage mimeMessage = mailSender.createMimeMessage();

        // 3. Dùng MimeMessageHelper
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
        helper.setTo(email);
        helper.setSubject("OTP Xác Thực - Web Xem Phim");

        // 4. Nội dung HTML với text block
        String htmlContent = """
        Mã Otp xác thực được gửi từ Web đặt vé xem phim <br>
        Mã OTP xác thực của bạn là: <h3>%s</h3>
        <p>Mã Otp sẽ hết hạn sau 5 phút.</p>  
        <p>Web xem phim cảm ơn bạn!</p>
        """.formatted(otp);

        helper.setText(htmlContent, true); // true = HTML

        // 5. Gửi mail
        mailSender.send(mimeMessage);
    }

}
