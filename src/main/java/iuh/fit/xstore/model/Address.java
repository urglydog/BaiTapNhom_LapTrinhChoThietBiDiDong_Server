package iuh.fit.xstore.model;

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
@Table(name = "addresses")
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "num_of_house")
    private int numOfHouse;
    private String street;
    private String city;
    private String country;
    @Column(name = "full_adrress")
    private String fullAddress;

}
