package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Discount;
import iuh.fit.xstore.service.DiscountService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/discounts")
@AllArgsConstructor
public class DiscountController {

    private final DiscountService discountService;

    @GetMapping
    ApiResponse<List<Discount>> getDiscounts() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, discountService.findAll());
    }

    @GetMapping("/{id}")
    public ApiResponse<Discount> getDiscount(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, discountService.findById(id));
    }

    @PostMapping
    ApiResponse<Discount> createDiscount(@RequestBody Discount discount) {
        Discount createdDiscount = discountService.createDiscount(discount);
        return new ApiResponse<>(SuccessCode.DISCOUNT_CREATED, createdDiscount);
    }

    @PutMapping("/{id}")
    ApiResponse<Discount> updateDiscount(@PathVariable int id, @RequestBody Discount discount) {
        discount.setId(id);
        Discount updatedDiscount = discountService.updateDiscount(discount);
        return new ApiResponse<>(SuccessCode.DISCOUNT_UPDATED, updatedDiscount);
    }

    @DeleteMapping("/{id}")
    ApiResponse<Integer> deleteDiscount(@PathVariable int id) {
        discountService.deleteDiscount(id);
        return new ApiResponse<>(SuccessCode.DISCOUNT_DELETED, id);
    }
}
