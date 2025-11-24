package iuh.fit.movieapp.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder

@Entity
@Table(name = "cinema_halls")
public class CinemaHall {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cinema_id", nullable = false)
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties({"halls", "cinemaHalls"})
    private Cinema cinema;

    // Getter để expose cinemaId trong JSON response
    @com.fasterxml.jackson.annotation.JsonGetter("cinemaId")
    public int getCinemaId() {
        return cinema != null ? cinema.getId() : 0;
    }

    // Getter để expose name (alias của hallName) trong JSON response
    @com.fasterxml.jackson.annotation.JsonGetter("name")
    public String getName() {
        return hallName;
    }

    @Column(name = "hall_name", nullable = false)
    private String hallName;

    @Column(name = "total_seats", nullable = false)
    private int totalSeats;

    @Column(name = "seat_layout", columnDefinition = "JSON")
    private String seatLayout;

    @Column(name = "is_active")
    @Builder.Default
    private Boolean active = true;

    @OneToMany(mappedBy = "cinemaHall", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Seat> seats;

    @OneToMany(mappedBy = "cinemaHall", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Showtime> showtimes;
}
