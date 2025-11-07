# Thư Mục Ảnh

Thư mục này chứa ảnh sẽ được upload lên Cloudinary.

## 📁 Cấu Trúc

```
images/
├── movies/          # Poster phim (5 ảnh)
│   ├── avatar-way-of-water.jpg
│   ├── black-panther-wakanda-forever.jpg
│   ├── top-gun-maverick.jpg
│   ├── spider-man-no-way-home.jpg
│   └── the-batman.jpg
└── cinemas/         # Ảnh rạp chiếu (4 ảnh)
    ├── cgv-vincom-center.jpg
    ├── lotte-cinema-diamond-plaza.jpg
    ├── galaxy-cinema-nguyen-du.jpg
    └── bhd-star-cineplex.jpg
```

## 🎬 Tải Ảnh Phim

### Cách 1: Tự Động (Khuyến nghị)
Chạy script PowerShell:
```powershell
.\download_movie_posters.ps1
```

### Cách 2: Tải Thủ Công
Tải từ các link sau (Right click → Save image as):

1. **Avatar: The Way of Water**
   - URL: https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg
   - Lưu thành: `avatar-way-of-water.jpg`

2. **Black Panther: Wakanda Forever**
   - URL: https://image.tmdb.org/t/p/w500/sv1xJUazXeYqALzczL3wBP5Qy7Q.jpg
   - Lưu thành: `black-panther-wakanda-forever.jpg`

3. **Top Gun: Maverick**
   - URL: https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg
   - Lưu thành: `top-gun-maverick.jpg`

4. **Spider-Man: No Way Home**
   - URL: https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg
   - Lưu thành: `spider-man-no-way-home.jpg`

5. **The Batman**
   - URL: https://image.tmdb.org/t/p/w500/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg
   - Lưu thành: `the-batman.jpg`

## 🏢 Tải Ảnh Rạp Chiếu

Tải thủ công từ Google Images:

1. **CGV Vincom Center**
   - Search: "CGV Vincom Center Ho Chi Minh"
   - Filter: Tools → Usage Rights → Labeled for reuse
   - Lưu thành: `cgv-vincom-center.jpg`

2. **Lotte Cinema Diamond Plaza**
   - Search: "Lotte Cinema Diamond Plaza Ho Chi Minh"
   - Filter: Tools → Usage Rights → Labeled for reuse
   - Lưu thành: `lotte-cinema-diamond-plaza.jpg`

3. **Galaxy Cinema Nguyễn Du**
   - Search: "Galaxy Cinema Nguyen Du Ho Chi Minh"
   - Filter: Tools → Usage Rights → Labeled for reuse
   - Lưu thành: `galaxy-cinema-nguyen-du.jpg`

4. **BHD Star Cineplex**
   - Search: "BHD Star Cineplex Ho Chi Minh"
   - Filter: Tools → Usage Rights → Labeled for reuse
   - Lưu thành: `bhd-star-cineplex.jpg`

## 📤 Upload Lên Cloudinary

Sau khi có đủ ảnh:

1. Upload vào `movie_ticket_app/movies/`:
   - Tất cả ảnh trong thư mục `movies/`

2. Upload vào `movie_ticket_app/cinemas/`:
   - Tất cả ảnh trong thư mục `cinemas/`

3. Copy URLs từ Cloudinary và cập nhật vào `data.sql`

## ✅ Checklist

- [ ] 5 ảnh phim đã tải vào `movies/`
- [ ] 4 ảnh rạp đã tải vào `cinemas/`
- [ ] Tên file đúng (không dấu, không khoảng trắng)
- [ ] Upload lên Cloudinary vào đúng folder
- [ ] Copy URLs và cập nhật `data.sql`

