package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Product;
import iuh.fit.xstore.model.ProductType;
import iuh.fit.xstore.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;
    
    public List<Product> findAll() {
        return productRepository.findAll();
    }
    
    public Product findById(int id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_NOT_FOUND));
    }
    
    public Product findByName(String name) {
        return productRepository.findByName(name)
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_NOT_FOUND));
    }
    
    public List<Product> findByType(ProductType type) {
        return productRepository.findByType(type);
    }
    
    public List<Product> findByTypeId(int typeId) {
        return productRepository.findByTypeId(typeId);
    }
    
    public List<Product> findByBrand(String brand) {
        return productRepository.findByBrand(brand);
    }
    
    public Product createProduct(Product product) {
        if (productRepository.existsByName(product.getName())) {
            throw new AppException(ErrorCode.PRODUCT_EXISTED);
        }
        return productRepository.save(product);
    }
    
    public Product updateProduct(Product product) {
        Product existingProduct = productRepository.findById(product.getId())
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_NOT_FOUND));
        
        existingProduct.setName(product.getName());
        existingProduct.setDescription(product.getDescription());
        existingProduct.setImage(product.getImage());
        existingProduct.setType(product.getType());
        existingProduct.setBrand(product.getBrand());
        existingProduct.setSize(product.getSize());
        existingProduct.setColor(product.getColor());
        existingProduct.setFabric(product.getFabric());
        existingProduct.setPriceInStock(product.getPriceInStock());
        existingProduct.setPrice(product.getPrice());
        
        return productRepository.save(existingProduct);
    }
    
    public int deleteProduct(int id) {
        findById(id); // Check if product exists
        productRepository.deleteById(id);
        return id;
    }
}