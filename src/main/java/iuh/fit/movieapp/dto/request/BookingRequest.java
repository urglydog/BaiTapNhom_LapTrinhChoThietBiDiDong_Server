package iuh.fit.movieapp.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookingRequest {
    private int showtimeId;
    private List<Integer> seatIds;
    private String paymentMethod;
    private String promotionCode;
}
