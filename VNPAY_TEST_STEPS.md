# Hướng dẫn Test VNPay - Bước tiếp theo

## Bước 1: Đã hoàn thành ✅
- Test endpoint `/api/vnpay/test` thành công
- Nhận được `paymentUrl` từ response

## Bước 2: Test Payment URL

### Cách 1: Test trực tiếp (Có thể gặp lỗi "Website chưa được phê duyệt")

1. **Copy `paymentUrl` từ Postman response**
   - Click vào `paymentUrl` trong JSON response
   - Hoặc copy toàn bộ URL

2. **Mở URL trong browser**
   - Paste URL vào address bar
   - Enter để mở

3. **Nếu gặp lỗi "Website chưa được phê duyệt":**
   - Cần setup ngrok (xem Bước 3)

### Cách 2: Test với ngrok (Khuyến nghị)

1. **Cài đặt ngrok:**
   ```bash
   # Download từ: https://ngrok.com/download
   # Hoặc dùng package manager
   ```

2. **Chạy ngrok:**
   ```bash
   ngrok http 8080
   ```

3. **Copy Forwarding URL** (ví dụ: `https://abc123.ngrok-free.app`)

4. **Đăng ký trong VNPay Sandbox:**
   - Đăng nhập: https://sandbox.vnpayment.vn/
   - Vào **Quản lý website**
   - Thêm website:
     - Website URL: `https://abc123.ngrok-free.app`
     - Return URL: `https://abc123.ngrok-free.app/api/vnpay/return`
     - IPN URL: `https://abc123.ngrok-free.app/api/vnpay/ipn`

5. **Cập nhật `application.properties`:**
   ```properties
   vnpay.returnUrl=https://abc123.ngrok-free.app/api/vnpay/return
   ```

6. **Restart Spring Boot**

7. **Test lại với ngrok URL:**
   ```bash
   curl "http://localhost:8080/api/vnpay/test?amount=100000"
   ```

## Bước 3: Test Thanh toán trên VNPay

### Thông tin thẻ test VNPay Sandbox:

**Thẻ 1:**
- Ngân hàng: **NCB**
- Số thẻ: `9704198526191432198`
- Tên chủ thẻ: `NGUYEN VAN A`
- Ngày phát hành: `07/15`
- Mã OTP: `123456`

**Thẻ 2:**
- Ngân hàng: **Vietcombank**
- Số thẻ: `9704361234567890`
- Tên chủ thẻ: `NGUYEN VAN B`
- Ngày phát hành: `07/15`
- Mã OTP: `123456`

### Quy trình thanh toán:

1. Mở `paymentUrl` trong browser
2. Chọn phương thức thanh toán (ATM, Credit Card, etc.)
3. Nhập thông tin thẻ test
4. Nhập OTP: `123456`
5. Xác nhận thanh toán

## Bước 4: Kiểm tra Return URL

Sau khi thanh toán:

1. **Nếu thành công:**
   - VNPay sẽ redirect về `/api/vnpay/return`
   - Bạn sẽ thấy trang HTML: "✓ Thanh toán thành công"
   - Booking status sẽ được cập nhật thành `PAID`

2. **Nếu thất bại:**
   - VNPay sẽ redirect về `/api/vnpay/return`
   - Bạn sẽ thấy trang HTML: "✗ Thanh toán thất bại"
   - Booking status sẽ được cập nhật thành `FAILED`

## Bước 5: Kiểm tra IPN (Instant Payment Notification)

VNPay sẽ tự động gọi IPN endpoint:
```
POST /api/vnpay/ipn
```

Để test IPN:
1. Xem logs trong Spring Boot console
2. Kiểm tra response từ IPN endpoint
3. Verify payment status được cập nhật

## Bước 6: Test với Booking thật

Sau khi test endpoint test thành công:

1. **Tạo booking thật từ frontend:**
   - Chọn VNPay làm phương thức thanh toán
   - Tạo booking

2. **Gọi API tạo payment:**
   ```bash
   POST /api/vnpay/create-payment?bookingId={bookingId}
   ```

3. **Lấy payment URL và thanh toán**

## Troubleshooting

### Lỗi "Website chưa được phê duyệt"
- **Giải pháp:** Dùng ngrok và đăng ký URL trong VNPay dashboard

### Lỗi "Invalid signature"
- Kiểm tra `vnp_HashSecret` trong `application.properties`
- Đảm bảo hash được tính đúng

### Return URL không hoạt động
- Kiểm tra ngrok đang chạy
- Kiểm tra Spring Boot đang chạy trên port 8080
- Kiểm tra URL đã được đăng ký trong VNPay

### Payment thành công nhưng status không update
- Kiểm tra IPN endpoint có được gọi không
- Kiểm tra logs trong console
- Verify booking code trong database

## Test nhanh không cần thanh toán thật

Nếu chỉ muốn test logic tạo URL:

1. ✅ Đã test: Endpoint `/api/vnpay/test` hoạt động
2. Kiểm tra `paymentUrl` có đầy đủ parameters:
   - `vnp_Amount`
   - `vnp_TxnRef`
   - `vnp_SecureHash`
   - `vnp_ReturnUrl`
3. Verify hash được tính đúng (so sánh với VNPay documentation)

## Next Steps

1. Setup ngrok để test full flow
2. Test thanh toán với thẻ test
3. Verify return URL hoạt động
4. Test với booking thật từ frontend

