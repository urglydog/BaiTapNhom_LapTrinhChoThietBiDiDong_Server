# Hướng dẫn Setup VNPay Sandbox để Test

## Vấn đề: "Website này chưa được phê duyệt"

Lỗi này xảy ra vì VNPay Sandbox yêu cầu đăng ký Return URL trước khi sử dụng. `localhost` không được chấp nhận.

## Giải pháp: Sử dụng ngrok để tạo Public URL

### Bước 1: Cài đặt ngrok

**Windows:**
1. Download từ: https://ngrok.com/download
2. Giải nén và đặt vào thư mục dễ truy cập
3. Hoặc dùng Chocolatey: `choco install ngrok`

**Mac:**
```bash
brew install ngrok
```

**Linux:**
```bash
# Download và giải nén
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/
```

### Bước 2: Chạy ngrok

1. **Chạy Spring Boot server:**
   ```bash
   cd Movie_App_Server/Nhom1111_AppXemPhim_Server
   mvn spring-boot:run
   ```

2. **Mở terminal mới và chạy ngrok:**
   ```bash
   ngrok http 8080
   ```

3. **Copy Forwarding URL** (ví dụ: `https://abc123.ngrok.io`)

### Bước 3: Đăng ký URL trong VNPay Sandbox

1. Đăng nhập vào VNPay Sandbox: https://sandbox.vnpayment.vn/
2. Vào **Quản lý website** hoặc **Website Management**
3. Thêm website mới với:
   - **Website URL:** `https://abc123.ngrok.io` (URL từ ngrok)
   - **Return URL:** `https://abc123.ngrok.io/api/vnpay/return`
   - **IPN URL:** `https://abc123.ngrok.io/api/vnpay/ipn`
4. Lưu và chờ phê duyệt (thường là ngay lập tức trong sandbox)

### Bước 4: Cập nhật application.properties

Cập nhật `vnpay.returnUrl` với ngrok URL:

```properties
vnpay.returnUrl=https://abc123.ngrok.io/api/vnpay/return
```

**Lưu ý:** Mỗi lần chạy ngrok, URL sẽ thay đổi (trừ khi dùng ngrok account có tên miền cố định).

### Bước 5: Restart Spring Boot và Test lại

1. Restart Spring Boot server
2. Test lại với endpoint: `http://localhost:8080/api/vnpay/test?amount=100000`
3. Mở payment URL và thử thanh toán

## Giải pháp thay thế: Sử dụng ngrok với domain cố định

### Ngrok Account (Free)

1. Đăng ký tài khoản tại: https://dashboard.ngrok.com/signup
2. Lấy authtoken từ dashboard
3. Cấu hình:
   ```bash
   ngrok config add-authtoken YOUR_AUTH_TOKEN
   ```

4. Chạy với domain cố định (free plan):
   ```bash
   ngrok http 8080 --domain=your-domain.ngrok-free.app
   ```

### Hoặc dùng Cloudflare Tunnel (Free, domain cố định)

1. Cài đặt cloudflared
2. Chạy:
   ```bash
   cloudflared tunnel --url http://localhost:8080
   ```

## Test không cần Return URL (Chỉ test tạo URL)

Nếu chỉ muốn test việc tạo payment URL mà không cần test full flow:

1. Dùng endpoint test: `GET /api/vnpay/test?amount=100000`
2. Copy `paymentUrl` từ response
3. Kiểm tra URL có đầy đủ parameters và hash không
4. Không cần thực sự thanh toán

## Lưu ý quan trọng

1. **ngrok URL thay đổi:** Mỗi lần restart ngrok, URL mới. Cần update lại trong VNPay dashboard
2. **ngrok Free có giới hạn:** 
   - Session timeout sau 2 giờ
   - Có thể bị rate limit
3. **Production:** Khi deploy lên Render, dùng domain thật và đăng ký trong VNPay Production

## Troubleshooting

### Lỗi "ngrok not found"
- Đảm bảo ngrok đã được cài đặt và trong PATH
- Windows: Thêm vào System Environment Variables

### Lỗi "ngrok session expired"
- Restart ngrok và update URL mới trong VNPay dashboard

### Lỗi "Connection refused"
- Đảm bảo Spring Boot đang chạy trên port 8080
- Kiểm tra firewall không block port 8080

### VNPay vẫn báo "Website chưa được phê duyệt"
- Kiểm tra URL trong VNPay dashboard đúng với ngrok URL
- Đảm bảo đã save và chờ vài phút để hệ thống cập nhật
- Thử clear cache browser

