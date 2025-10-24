package iuh.fit.xstore.model;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder
@Embeddable
public class FavouriteID implements Serializable{
    private int userId;
    private int productId;
}
