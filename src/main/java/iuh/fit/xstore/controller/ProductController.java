package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Product;
import iuh.fit.xstore.service.ProductService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
@AllArgsConstructor
public class ProductController {
    private final ProductService productService;

    @GetMapping
    public ApiResponse<List<Product>> getAllProducts() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, productService.findAll());
    }

    @GetMapping("/{id}")
    public ApiResponse<Product> getProductById(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, productService.findById(id));
    }

    @GetMapping("/type/{typeId}")
    public ApiResponse<List<Product>> getProductsByTypeId(@PathVariable int typeId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, productService.findByTypeId(typeId));
    }

    @PostMapping
    public ApiResponse<Product> createProduct(@RequestBody Product product) {
        Product createdProduct = productService.createProduct(product);
        return new ApiResponse<>(SuccessCode.PRODUCT_CREATED, createdProduct);
    }

    @PutMapping("/{id}")
    public ApiResponse<Product> updateProduct(@PathVariable int id, @RequestBody Product product) {
        product.setId(id);
        Product updatedProduct = productService.updateProduct(product);
        return new ApiResponse<>(SuccessCode.PRODUCT_UPDATED, updatedProduct);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Integer> deleteProduct(@PathVariable int id) {
        productService.deleteProduct(id);
        return new ApiResponse<>(SuccessCode.PRODUCT_DELETED, id);
    }
}