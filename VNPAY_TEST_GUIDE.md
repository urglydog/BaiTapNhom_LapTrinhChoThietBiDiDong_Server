# Hướng dẫn Test VNPay API

## 1. Test Endpoint (Không cần deploy)

### Test tạo Payment URL

**Endpoint:** `GET /api/vnpay/test?amount=100000`

**Ví dụ với curl:**
```bash
curl "http://localhost:8080/api/vnpay/test?amount=100000"
```

**Ví dụ với Postman:**
- Method: GET
- URL: `http://localhost:8080/api/vnpay/test?amount=100000`
- Headers: Không cần

**Response:**
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": {
    "paymentUrl": "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?...",
    "testBookingCode": "TEST1234567890",
    "amount": "100000",
    "message": "Test payment URL created successfully. Click paymentUrl to test VNPay."
  }
}
```

### Test với các số tiền khác nhau:
```bash
# 50,000 VNĐ
curl "http://localhost:8080/api/vnpay/test?amount=50000"

# 200,000 VNĐ
curl "http://localhost:8080/api/vnpay/test?amount=200000"

# 1,000,000 VNĐ
curl "http://localhost:8080/api/vnpay/test?amount=1000000"
```

## 2. Test Payment Flow Hoàn Chỉnh

### Bước 1: Tạo Payment URL
```bash
curl "http://localhost:8080/api/vnpay/test?amount=100000"
```

### Bước 2: Copy `paymentUrl` từ response và mở trong browser

### Bước 3: Test thanh toán trên VNPay Sandbox

**Thông tin thẻ test VNPay Sandbox:**
- **Ngân hàng:** NCB
- **Số thẻ:** `9704198526191432198`
- **Tên chủ thẻ:** `NGUYEN VAN A`
- **Ngày phát hành:** `07/15`
- **Mã OTP:** `123456`

Hoặc dùng các thẻ test khác từ: https://sandbox.vnpayment.vn/apis/

### Bước 4: Kiểm tra Return URL

Sau khi thanh toán, VNPay sẽ redirect về:
```
http://localhost:8080/api/vnpay/return?vnp_Amount=10000000&vnp_BankCode=NCB&...
```

Bạn sẽ thấy trang HTML với thông báo kết quả thanh toán.

## 3. Test với Postman Collection

Tạo collection với các request:

### Request 1: Test Create Payment URL
```
GET http://localhost:8080/api/vnpay/test?amount=100000
```

### Request 2: Test Return URL (Simulate)
```
GET http://localhost:8080/api/vnpay/return?vnp_Amount=10000000&vnp_BankCode=NCB&vnp_ResponseCode=00&vnp_TxnRef=TEST1234567890&vnp_SecureHash=...
```

## 4. Test với Browser

1. Mở browser và truy cập:
   ```
   http://localhost:8080/api/vnpay/test?amount=100000
   ```

2. Copy `paymentUrl` từ JSON response

3. Mở URL đó trong tab mới

4. Thực hiện thanh toán test

5. Kiểm tra kết quả

## 5. Kiểm tra Logs

Xem logs trong console để debug:
- Payment URL được tạo
- Hash được tính toán
- IPN được gọi
- Return URL được xử lý

## 6. Test IPN (Instant Payment Notification)

VNPay sẽ tự động gọi IPN endpoint sau khi thanh toán:
```
POST http://localhost:8080/api/vnpay/ipn
```

Để test IPN, bạn có thể dùng ngrok để expose local server:
```bash
ngrok http 8080
```

Sau đó cập nhật IPN URL trong VNPay dashboard (nếu có).

## 7. Lưu ý

- **Sandbox:** Chỉ dùng để test, không có giao dịch thật
- **Local:** Cần chạy server trên `localhost:8080`
- **Return URL:** Phải accessible từ internet (dùng ngrok nếu test từ VNPay server)
- **HTTPS:** Production cần HTTPS cho return URL

## 8. Troubleshooting

### Lỗi "Invalid signature"
- Kiểm tra `vnp_HashSecret` trong `application.properties`
- Đảm bảo hash được tính đúng

### Lỗi "Cannot connect"
- Kiểm tra server đang chạy
- Kiểm tra port 8080 không bị block

### Payment URL không mở được
- Kiểm tra URL có đầy đủ parameters
- Kiểm tra VNPay sandbox đang hoạt động

