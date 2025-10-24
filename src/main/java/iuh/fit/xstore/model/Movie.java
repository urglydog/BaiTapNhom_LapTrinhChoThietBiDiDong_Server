package iuh.fit.xstore.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder

@Entity
@Table(name = "movies")
public class Movie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "duration", nullable = false)
    private int duration; // Thời lượng phim (phút)

    @Column(name = "release_date", nullable = false)
    private LocalDate releaseDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "genre")
    private String genre;

    @Column(name = "director")
    private String director;

    @Column(name = "cast", columnDefinition = "TEXT")
    private String cast;

    @Column(name = "rating", precision = 2, scale = 1)
    private BigDecimal rating = BigDecimal.ZERO;

    @Column(name = "poster_url")
    private String posterUrl;

    @Column(name = "trailer_url")
    private String trailerUrl;

    @Column(name = "language")
    private String language;

    @Column(name = "subtitle")
    private String subtitle;

    @Column(name = "age_rating")
    private String ageRating;

    @Column(name = "is_active")
    private boolean isActive = true;

    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Showtime> showtimes;

    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Review> reviews;

    @OneToMany(mappedBy = "movie", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Favourite> favourites;
}
