package iuh.fit.xstore.model;

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
    @JsonBackReference
    private Cinema cinema;

    @Column(name = "hall_name", nullable = false)
    private String hallName;

    @Column(name = "total_seats", nullable = false)
    private int totalSeats;

    @Column(name = "seat_layout", columnDefinition = "JSON")
    private String seatLayout;

    @Column(name = "is_active")
    private boolean isActive = true;

    @OneToMany(mappedBy = "cinemaHall", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Seat> seats;

    @OneToMany(mappedBy = "cinemaHall", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Showtime> showtimes;
}
