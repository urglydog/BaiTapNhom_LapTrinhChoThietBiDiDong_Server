package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Discount;
import iuh.fit.xstore.repository.DiscountRepository;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@AllArgsConstructor
public class DiscountService {

    private final DiscountRepository discountRepository;

    public List<Discount> findAll() {
        return discountRepository.findAll();
    }

    public Discount findById(int id) {
        return discountRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, ErrorCode.DISCOUNT_NOT_FOUND.getMessage()
                ));
    }

    public Discount createDiscount(Discount discount) {
        return discountRepository.save(discount);
    }

    public Discount updateDiscount(Discount discount) {
        if (!discountRepository.existsById(discount.getId())) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, ErrorCode.DISCOUNT_NOT_FOUND.getMessage()
            );
        }
        return discountRepository.save(discount);
    }

    public void deleteDiscount(int id) {
        if (!discountRepository.existsById(id)) {
            throw new ResponseStatusException(
                    HttpStatus.NOT_FOUND, ErrorCode.DISCOUNT_NOT_FOUND.getMessage()
            );
        }
        discountRepository.deleteById(id);
    }
}
