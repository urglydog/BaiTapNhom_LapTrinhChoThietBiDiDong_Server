package iuh.fit.movieapp.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder

@Entity
@Table(name = "showtimes")
public class Showtime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "movie_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"showtimes", "favourites", "reviews"})
    private Movie movie;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cinema_hall_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"showtimes", "seats"})
    private CinemaHall cinemaHall;

    // Getter để expose cinemaHallId trong JSON response
    @com.fasterxml.jackson.annotation.JsonGetter("cinemaHallId")
    public int getCinemaHallId() {
        return cinemaHall != null ? cinemaHall.getId() : 0;
    }

    @Column(name = "show_date", nullable = false)
    private LocalDate showDate;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean active = true;

    @OneToMany(mappedBy = "showtime", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Booking> bookings;
}
