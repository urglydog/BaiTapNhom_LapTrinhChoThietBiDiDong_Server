package iuh.fit.xstore.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder

@Entity
@Table(name = "seats")
public class Seat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cinema_hall_id", nullable = false)
    @JsonBackReference
    private CinemaHall cinemaHall;

    @Column(name = "seat_number", nullable = false)
    private String seatNumber;

    @Column(name = "seat_row", nullable = false)
    private String seatRow;

    @Enumerated(EnumType.STRING)
    @Column(name = "seat_type")
    @Builder.Default
    private SeatType seatType = SeatType.NORMAL;

    @Column(name = "is_active")
    @Builder.Default
    private boolean isActive = true;

    public enum SeatType {
        NORMAL, VIP, COUPLE
    }
}
