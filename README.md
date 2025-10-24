# Movie Ticket Booking System Backend

This is the backend API for a mobile movie ticket booking application built with Expo + React Native + TypeScript.

## Features

- User authentication and authorization (Admin, Staff, Customer roles)
- Movie management
- Cinema and cinema hall management
- Showtime scheduling
- Seat booking system
- Booking management
- Review and rating system
- Favourite movies
- Promotion system

## Technology Stack

- Java 17
- Spring Boot 3.x
- Spring Security
- JWT Authentication
- JPA/Hibernate
- MariaDB
- Maven

## Database Schema

The system includes the following main entities:
- **Users** - Customer, Staff, Admin roles
- **Movies** - Movie information and details
- **Cinemas** - Cinema locations and information
- **Cinema Halls** - Individual screening rooms
- **Showtimes** - Movie screening schedules
- **Seats** - Individual seat management
- **Bookings** - Ticket booking records
- **Reviews** - Movie reviews and ratings
- **Favourites** - User's favourite movies
- **Promotions** - Discount and promotion codes

## Getting Started

1. **Database Setup**:
   - Install MariaDB
   - Run the SQL script in `movie_ticket_database.sql` to create the database and sample data

2. **Application Configuration**:
   - Update `application.properties` with your database credentials
   - Default database: `movie_ticket_db`
   - Default port: `8080`

3. **Run the Application**:
   ```bash
   mvn spring-boot:run
   ```

4. **API Access**:
   - Base URL: `http://localhost:8080`
   - API Documentation: `http://localhost:8080/api`

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Refresh JWT token

### Movies
- `GET /api/movies` - Get all movies
- `GET /api/movies/active` - Get active movies
- `GET /api/movies/currently-showing` - Get currently showing movies
- `GET /api/movies/upcoming` - Get upcoming movies
- `GET /api/movies/{id}` - Get movie by ID

### Cinemas
- `GET /api/cinemas` - Get all cinemas
- `GET /api/cinemas/active` - Get active cinemas
- `GET /api/cinemas/city/{city}` - Get cinemas by city

### Showtimes
- `GET /api/showtimes` - Get all showtimes
- `GET /api/showtimes/movie/{movieId}` - Get showtimes by movie
- `GET /api/showtimes/cinema-hall/{cinemaHallId}` - Get showtimes by cinema hall

### Bookings
- `POST /api/bookings` - Create new booking
- `GET /api/bookings/user/{userId}` - Get user bookings
- `GET /api/bookings/booking-code/{bookingCode}` - Get booking by code

### Reviews
- `GET /api/reviews/movie/{movieId}` - Get movie reviews
- `POST /api/reviews` - Create review
- `PUT /api/reviews/{id}/approve` - Approve review (Admin/Staff)

### Favourites
- `GET /api/favourites/user/{userId}` - Get user favourites
- `POST /api/favourites/user/{userId}/movie/{movieId}` - Add to favourites
- `DELETE /api/favourites/{id}` - Remove from favourites

## Sample Data

The database script includes sample data for:
- 3 user roles (Admin, Staff, Customer)
- 4 cinemas in Ho Chi Minh City
- 5 popular movies
- Multiple showtimes and seat configurations
- Sample bookings and reviews

## Security

- JWT-based authentication
- Role-based access control (RBAC)
- Password encryption using BCrypt
- CORS enabled for mobile app integration

## Mobile App Integration

This backend is designed to work with a React Native mobile app using Expo. The API supports:
- RESTful endpoints
- JSON responses
- CORS headers for cross-origin requests
- JWT token authentication
- Mobile-optimized response formats
