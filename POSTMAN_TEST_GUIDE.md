# 🚀 Postman Test Guide for Railway API

## 📋 Tổng quan

Hướng dẫn test API endpoints với Postman sau khi insert dữ liệu mẫu.

## 🔧 Setup

### **1. Insert Sample Data**
```bash
# Chạy script insert dữ liệu mẫu
insert_railway_data.bat
```

### **2. Base URL**
```
https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com
```

## 📡 API Endpoints

### **1. Users API**

#### **GET /api/users**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/users`
- **Method**: GET
- **Expected Response**:
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": [
    {
      "id": 1,
      "username": "admin",
      "email": "admin@movieticket.com",
      "full_name": "Admin System",
      "role": "ADMIN"
    },
    {
      "id": 2,
      "username": "staff1",
      "email": "staff1@movieticket.com",
      "full_name": "Nguyễn Văn A",
      "role": "STAFF"
    }
  ]
}
```

#### **GET /api/users/{id}**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/users/1`
- **Method**: GET
- **Expected Response**:
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": {
    "id": 1,
    "username": "admin",
    "email": "admin@movieticket.com",
    "full_name": "Admin System",
    "role": "ADMIN"
  }
}
```

### **2. Movies API**

#### **GET /api/movies**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/movies`
- **Method**: GET
- **Expected Response**:
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": [
    {
      "id": 1,
      "title": "Avatar: The Way of Water",
      "description": "Jake Sully và gia đình của anh ấy khám phá những vùng biển của Pandora...",
      "duration": 192,
      "genre": "Sci-Fi, Action",
      "rating": 8.5
    }
  ]
}
```

#### **GET /api/movies/{id}**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/movies/1`
- **Method**: GET

### **3. Cinemas API**

#### **GET /api/cinemas**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/cinemas`
- **Method**: GET
- **Expected Response**:
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": [
    {
      "id": 1,
      "name": "CGV Vincom Center",
      "address": "72 Lê Thánh Tôn, Quận 1, TP.HCM",
      "city": "Ho Chi Minh City"
    }
  ]
}
```

### **4. Showtimes API**

#### **GET /api/showtimes**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/showtimes`
- **Method**: GET
- **Expected Response**:
```json
{
  "code": 200,
  "message": "Data fetched successfully",
  "result": [
    {
      "id": 1,
      "movie_id": 1,
      "cinema_hall_id": 1,
      "show_date": "2023-01-15",
      "start_time": "09:00:00",
      "end_time": "12:12:00",
      "price": 120000
    }
  ]
}
```

### **5. Reviews API**

#### **GET /api/reviews**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/reviews`
- **Method**: GET

### **6. Favourites API**

#### **GET /api/favourites**
- **URL**: `https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/favourites`
- **Method**: GET

## 🧪 Test Cases

### **Test Case 1: Basic API Health**
1. **GET /api/users** - Should return 200 with user list
2. **GET /api/movies** - Should return 200 with movie list
3. **GET /api/cinemas** - Should return 200 with cinema list

### **Test Case 2: Data Validation**
1. **GET /api/users/1** - Should return admin user
2. **GET /api/movies/1** - Should return Avatar movie
3. **GET /api/cinemas/1** - Should return CGV cinema

### **Test Case 3: Error Handling**
1. **GET /api/users/999** - Should return 404 or empty result
2. **GET /api/movies/999** - Should return 404 or empty result

## 📊 Sample Data Overview

### **Users (4 records)**
- Admin System (ADMIN)
- Nguyễn Văn A (STAFF)
- Trần Thị B (CUSTOMER)
- Lê Văn C (CUSTOMER)

### **Cinemas (4 records)**
- CGV Vincom Center
- Lotte Cinema Diamond Plaza
- Galaxy Cinema Nguyễn Du
- BHD Star Cineplex

### **Movies (5 records)**
- Avatar: The Way of Water
- Black Panther: Wakanda Forever
- Top Gun: Maverick
- Spider-Man: No Way Home
- The Batman

### **Showtimes (8 records)**
- Various showtimes for different movies
- Different time slots and prices

### **Seats (60 records)**
- Sample seat layout for cinema hall 1
- Different seat types (NORMAL, VIP)

### **Reviews (5 records)**
- User reviews for movies
- Ratings and comments

### **Favourites (4 records)**
- User favourite movies

### **Promotions (3 records)**
- Welcome discount
- VIP discount
- Weekend discount

## 🎯 Expected Results

Sau khi insert dữ liệu mẫu:
- ✅ **Users API** - Returns 4 users
- ✅ **Movies API** - Returns 5 movies
- ✅ **Cinemas API** - Returns 4 cinemas
- ✅ **Showtimes API** - Returns 8 showtimes
- ✅ **Reviews API** - Returns 5 reviews
- ✅ **Favourites API** - Returns 4 favourites
- ✅ **Promotions API** - Returns 3 promotions

## 📞 Troubleshooting

Nếu gặp lỗi:
1. **Check Railway deployment** - Ensure app is running
2. **Check database connection** - Verify Railway MySQL is accessible
3. **Check data insertion** - Run `insert_railway_data.bat`
4. **Check API logs** - Look for database connection errors
5. **Check CORS** - Ensure CORS is configured correctly
