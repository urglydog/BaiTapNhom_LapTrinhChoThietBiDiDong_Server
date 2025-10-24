@echo off
echo =============================================
echo Test Railway API Endpoints
echo =============================================

set BASE_URL=https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com

echo 1. Testing Users API...
curl -X GET "%BASE_URL%/api/users" -H "Content-Type: application/json"

echo.
echo 2. Testing Movies API...
curl -X GET "%BASE_URL%/api/movies" -H "Content-Type: application/json"

echo.
echo 3. Testing Cinemas API...
curl -X GET "%BASE_URL%/api/cinemas" -H "Content-Type: application/json"

echo.
echo 4. Testing Showtimes API...
curl -X GET "%BASE_URL%/api/showtimes" -H "Content-Type: application/json"

echo.
echo 5. Testing Reviews API...
curl -X GET "%BASE_URL%/api/reviews" -H "Content-Type: application/json"

echo.
echo 6. Testing Favourites API...
curl -X GET "%BASE_URL%/api/favourites" -H "Content-Type: application/json"

echo.
echo 7. Testing specific user (ID=1)...
curl -X GET "%BASE_URL%/api/users/1" -H "Content-Type: application/json"

echo.
echo 8. Testing specific movie (ID=1)...
curl -X GET "%BASE_URL%/api/movies/1" -H "Content-Type: application/json"

echo.
echo 9. Testing specific cinema (ID=1)...
curl -X GET "%BASE_URL%/api/cinemas/1" -H "Content-Type: application/json"

echo =============================================
echo API testing completed!
echo =============================================
echo.
echo If you see data in the responses, the API is working correctly!
echo You can now use Postman to test these endpoints.
echo =============================================
pause
