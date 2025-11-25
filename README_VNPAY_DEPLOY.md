# Hướng dẫn Deploy VNPay lên Render

## ✅ Kiểm tra trước khi deploy

### Backend đã sẵn sàng:
- ✅ VNPayConfig.java - Cấu hình VNPay
- ✅ VNPayService.java - Service xử lý thanh toán  
- ✅ VNPayController.java - API endpoints
- ✅ SecurityConfig.java - Đã thêm public endpoints
- ✅ Không có lỗi compile

### Frontend đã sẵn sàng:
- ✅ vnpayService.ts - Service gọi API
- ✅ booking.tsx - Đã tích hợp VNPay flow
- ✅ Import và sử dụng đúng

## 🚀 Các bước deploy

### 1. Deploy Backend lên Render

1. Push code lên Git
2. Deploy trên Render dashboard
3. Lấy URL Render (ví dụ: `https://your-app.onrender.com`)

### 2. Cấu hình Environment Variables trên Render

Vào **Environment** tab, thêm các biến sau:

```bash
vnpay.tmnCode=ZCY1WUK8
vnpay.hashSecret=LINMU8IHH2AWXGG3V5KNO3K6GNP09KW0
vnpay.url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
vnpay.api=https://sandbox.vnpayment.vn/merchant_webapi/api/transaction
vnpay.returnUrl=https://your-app.onrender.com/api/vnpay/return
```

**⚠️ QUAN TRỌNG:** Thay `your-app.onrender.com` bằng URL thật của bạn trên Render!

### 3. Đăng ký URL trong VNPay Sandbox

1. Đăng nhập: https://sandbox.vnpayment.vn/
2. Vào **Quản lý website** / **Website Management**
3. Thêm website:
   - **Website URL:** `https://your-app.onrender.com`
   - **Return URL:** `https://your-app.onrender.com/api/vnpay/return`
   - **IPN URL:** `https://your-app.onrender.com/api/vnpay/ipn`
4. Lưu và chờ phê duyệt

### 4. Test sau khi deploy

**Test endpoint:**
```bash
GET https://your-app.onrender.com/api/vnpay/test?amount=100000
```

**Test từ frontend:**
1. Mở app
2. Chọn VNPay khi đặt vé
3. Kiểm tra payment URL được tạo
4. Test thanh toán với thẻ test

## 📋 Checklist

- [ ] Backend đã deploy lên Render
- [ ] Environment variables đã set trên Render
- [ ] URL đã đăng ký trong VNPay Sandbox
- [ ] Test endpoint `/api/vnpay/test` hoạt động
- [ ] Frontend có thể gọi API
- [ ] Payment flow hoạt động

## ⚠️ Lưu ý

1. **Return URL phải HTTPS** - Render tự động cung cấp
2. **Phải đăng ký URL trong VNPay** - Không thể dùng localhost
3. **Set environment variables trên Render** - Không hardcode trong code

## 🐛 Troubleshooting

### "Website chưa được phê duyệt"
→ Kiểm tra URL đã đăng ký trong VNPay chưa

### "Invalid signature"  
→ Kiểm tra `vnpay.hashSecret` đúng chưa

### Return URL không hoạt động
→ Kiểm tra URL có HTTPS và đúng endpoint không

