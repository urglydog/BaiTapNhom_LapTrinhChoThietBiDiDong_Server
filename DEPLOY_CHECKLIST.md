# Checklist Deploy VNPay lên Render

## ✅ Backend Spring Boot - Đã sẵn sàng

### 1. Code đã hoàn chỉnh ✅
- [x] `VNPayConfig.java` - Cấu hình VNPay
- [x] `VNPayService.java` - Service xử lý logic thanh toán
- [x] `VNPayController.java` - API endpoints
- [x] Security config đã thêm public endpoints
- [x] Không có lỗi compile

### 2. Endpoints đã tạo ✅
- [x] `GET /api/vnpay/test` - Test endpoint (public)
- [x] `POST /api/vnpay/create-payment` - Tạo payment URL (cần auth)
- [x] `GET /api/vnpay/return` - Callback từ VNPay (public)
- [x] `POST /api/vnpay/ipn` - IPN từ VNPay (public)

### 3. Frontend đã tích hợp ✅
- [x] `vnpayService.ts` - Service gọi API
- [x] `booking.tsx` - Đã tích hợp VNPay flow
- [x] Import `vnpayService` đã đúng
- [x] Logic xử lý VNPay payment đã hoàn chỉnh

## 📋 Cần làm khi deploy lên Render

### Bước 1: Deploy Backend lên Render

1. **Push code lên Git:**
   ```bash
   git add .
   git commit -m "Add VNPay integration"
   git push
   ```

2. **Deploy trên Render:**
   - Vào Render dashboard
   - Chọn service Spring Boot
   - Deploy latest commit

3. **Lấy URL Render:**
   - URL sẽ có dạng: `https://your-app.onrender.com`
   - Copy URL này

### Bước 2: Cấu hình Environment Variables trên Render

Vào **Environment** tab trong Render dashboard, thêm:

```bash
# VNPay Configuration
vnpay.tmnCode=ZCY1WUK8
vnpay.hashSecret=LINMU8IHH2AWXGG3V5KNO3K6GNP09KW0
vnpay.url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
vnpay.api=https://sandbox.vnpayment.vn/merchant_webapi/api/transaction
vnpay.returnUrl=https://your-app.onrender.com/api/vnpay/return
```

**Lưu ý:** Thay `your-app.onrender.com` bằng URL thật của bạn.

### Bước 3: Đăng ký URL trong VNPay Sandbox

1. **Đăng nhập VNPay Sandbox:**
   - URL: https://sandbox.vnpayment.vn/
   - Đăng nhập với tài khoản sandbox

2. **Vào Quản lý website:**
   - Tìm mục "Quản lý website" hoặc "Website Management"

3. **Thêm website mới:**
   - **Website URL:** `https://your-app.onrender.com`
   - **Return URL:** `https://your-app.onrender.com/api/vnpay/return`
   - **IPN URL:** `https://your-app.onrender.com/api/vnpay/ipn`

4. **Lưu và chờ phê duyệt** (thường ngay lập tức trong sandbox)

### Bước 4: Test sau khi deploy

1. **Test endpoint test:**
   ```bash
   GET https://your-app.onrender.com/api/vnpay/test?amount=100000
   ```

2. **Kiểm tra response:**
   - Có `paymentUrl` trong response
   - `paymentUrl` có chứa return URL đúng

3. **Test từ frontend:**
   - Mở app
   - Chọn VNPay khi đặt vé
   - Kiểm tra payment URL được tạo
   - Test thanh toán

## 🔍 Kiểm tra trước khi deploy

### Backend
- [x] Code compile không lỗi
- [x] Tất cả endpoints đã tạo
- [x] Security config đúng
- [x] Application.properties có cấu hình VNPay

### Frontend
- [x] `vnpayService.ts` đã tạo
- [x] `booking.tsx` đã import và sử dụng
- [x] Logic xử lý VNPay đã đúng
- [x] Error handling đã có

### Integration
- [x] API endpoint path đúng: `/api/vnpay/create-payment`
- [x] Frontend gọi đúng endpoint
- [x] Payment flow đã hoàn chỉnh

## ⚠️ Lưu ý quan trọng

1. **Return URL phải HTTPS:**
   - Render tự động cung cấp HTTPS
   - Đảm bảo return URL dùng `https://`

2. **VNPay Sandbox cần đăng ký URL:**
   - Không thể dùng localhost
   - Phải đăng ký URL Render trước

3. **Environment Variables:**
   - Set trên Render dashboard
   - Không hardcode trong code

4. **Test trước khi production:**
   - Dùng sandbox để test
   - Verify payment flow hoạt động
   - Kiểm tra return URL và IPN

## 🚀 Sau khi deploy

1. ✅ Backend đã deploy lên Render
2. ✅ Environment variables đã set
3. ✅ URL đã đăng ký trong VNPay Sandbox
4. ✅ Test endpoint hoạt động
5. ✅ Frontend có thể gọi API
6. ✅ Payment flow hoạt động

## 📝 Troubleshooting

### Lỗi "Website chưa được phê duyệt"
- Kiểm tra URL đã đăng ký trong VNPay chưa
- Đảm bảo URL đúng với Render URL
- Chờ vài phút để hệ thống cập nhật

### Lỗi "Invalid signature"
- Kiểm tra `vnpay.hashSecret` đúng chưa
- Verify hash được tính đúng

### Return URL không hoạt động
- Kiểm tra URL có HTTPS không
- Kiểm tra endpoint `/api/vnpay/return` có public không
- Kiểm tra logs trên Render

