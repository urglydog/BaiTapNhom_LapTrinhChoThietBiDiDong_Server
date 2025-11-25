package iuh.fit.movieapp.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
@Data
public class VNPayConfig {
    
    @Value("${vnpay.tmnCode:ZCY1WUK8}")
    private String tmnCode;
    
    @Value("${vnpay.hashSecret:LINMU8IHH2AWXGG3V5KNO3K6GNP09KW0}")
    private String hashSecret;
    
    @Value("${vnpay.url:https://sandbox.vnpayment.vn/paymentv2/vpcpay.html}")
    private String url;
    
    @Value("${vnpay.api:https://sandbox.vnpayment.vn/merchant_webapi/api/transaction}")
    private String api;
    
    @Value("${vnpay.returnUrl:http://localhost:8080/api/vnpay/return}")
    private String returnUrl;
    
    @Value("${server.port:8080}")
    private String serverPort;
    
    @Value("${server.address:localhost}")
    private String serverAddress;
}

