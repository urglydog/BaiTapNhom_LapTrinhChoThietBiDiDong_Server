package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.ProductType;
import iuh.fit.xstore.service.ProductTypeService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/product-types")
@AllArgsConstructor
public class ProductTypeController {
    private final ProductTypeService productTypeService;

    @GetMapping
    public ApiResponse<List<ProductType>> getAllProductTypes() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, productTypeService.findAll());
    }

    @GetMapping("/{id}")
    public ApiResponse<ProductType> getProductTypeById(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, productTypeService.findById(id));
    }

    @PostMapping
    public ApiResponse<ProductType> createProductType(@RequestBody ProductType productType) {
        ProductType createdProductType = productTypeService.createProductType(productType);
        return new ApiResponse<>(SuccessCode.PRODUCT_TYPE_CREATED, createdProductType);
    }

    @PutMapping("/{id}")
    public ApiResponse<ProductType> updateProductType(@PathVariable int id, @RequestBody ProductType productType) {
        productType.setId(id);
        ProductType updatedProductType = productTypeService.updateProductType(productType);
        return new ApiResponse<>(SuccessCode.PRODUCT_TYPE_UPDATED, updatedProductType);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Integer> deleteProductType(@PathVariable int id) {
        productTypeService.deleteProductType(id);
        return new ApiResponse<>(SuccessCode.PRODUCT_TYPE_DELETED, id);
    }
}