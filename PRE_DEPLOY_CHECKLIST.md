# Checklist Trước Khi Deploy

## ✅ Kiểm Tra Trước Khi Commit

### 1. Kiểm Tra URLs Cloudinary
- [ ] Tất cả 20 URLs trong `data.sql` đã được thay thế từ Unsplash sang Cloudinary
- [ ] URLs có format đúng: `https://res.cloudinary.com/{cloud_name}/image/upload/...`
- [ ] Test mở vài URLs trong browser để đảm bảo ảnh hiển thị đúng

### 2. Kiểm Tra File data.sql
- [ ] File `src/main/resources/data.sql` có 20 phim
- [ ] Tất cả URLs đều là Cloudinary URLs (không còn Unsplash)
- [ ] Syntax SQL đúng (dấu ngoặc, dấu phẩy)

### 3. Kiểm Tra application.properties
**Lưu ý quan trọng:**
- Hiện tại: `spring.sql.init.mode=never` 
- Nếu bạn muốn Spring Boot tự động chạy `data.sql` khi khởi động, đổi thành:
  ```properties
  spring.sql.init.mode=always
  ```
- Nếu bạn đã chạy `data.sql` thủ công trên Railway, giữ `never` là được

### 4. Kiểm Tra Database
- [ ] Database trên Railway đã có bảng (JPA sẽ tự tạo với `ddl-auto=update`)
- [ ] Nếu chưa có dữ liệu, cần chạy `data.sql` thủ công hoặc đổi `spring.sql.init.mode=always`

## 📤 Bước Deploy

### 1. Commit Code
```bash
git add .
git commit -m "Add 20 movies with Cloudinary image URLs"
git push origin main
```

### 2. Deploy trên Render
- Render sẽ tự động build và deploy khi có commit mới
- Hoặc trigger manual deploy từ Render dashboard

### 3. Sau Khi Deploy

#### Nếu `spring.sql.init.mode=never`:
- Cần chạy `data.sql` thủ công trên Railway:
  1. Vào Railway Dashboard
  2. Mở MySQL database
  3. Copy nội dung `data.sql`
  4. Chạy trong SQL editor

#### Nếu `spring.sql.init.mode=always`:
- Spring Boot sẽ tự động chạy `data.sql` khi khởi động
- Kiểm tra logs để đảm bảo không có lỗi

## 🧪 Test Sau Khi Deploy

1. **Test API Movies:**
   ```
   GET https://your-render-url.onrender.com/api/movies
   ```
   - Kiểm tra có 20 phim
   - Kiểm tra `poster_url` là URLs Cloudinary

2. **Test Hiển Thị Ảnh:**
   - Mở một vài `poster_url` trong browser
   - Đảm bảo ảnh load được

3. **Test Mobile App:**
   - Kiểm tra ảnh hiển thị đúng trên app
   - Kiểm tra không có lỗi 404

## ⚠️ Lưu Ý Quan Trọng

1. **Database trên Railway:**
   - Nếu database đã có dữ liệu cũ, có thể cần xóa và tạo lại
   - Hoặc dùng `INSERT IGNORE` để tránh duplicate

2. **Ảnh Cloudinary:**
   - Đảm bảo tất cả ảnh đã được upload vào đúng folder
   - Kiểm tra URLs có đúng `cloud_name` không

3. **Environment Variables:**
   - Nếu có thay đổi trong `application.properties`, kiểm tra lại trên Render

## ✅ Hoàn Thành

Sau khi hoàn thành tất cả checklist:
- [ ] Code đã được commit
- [ ] Deploy thành công
- [ ] Test API thành công
- [ ] Ảnh hiển thị đúng trên app

🎉 **Xong! Bạn đã sẵn sàng deploy!**

