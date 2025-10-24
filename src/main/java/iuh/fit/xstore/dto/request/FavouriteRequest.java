package iuh.fit.xstore.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FavouriteRequest {
    private int userId;
    private int productId;
}
