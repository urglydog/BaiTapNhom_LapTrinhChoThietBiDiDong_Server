package iuh.fit.movieapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.mail.MailSenderValidatorAutoConfiguration;

@SpringBootApplication(exclude = {MailSenderValidatorAutoConfiguration.class})
public class MovieTicketBookingApplication {

    public static void main(String[] args) {
        SpringApplication.run(MovieTicketBookingApplication.class, args);
    }

}