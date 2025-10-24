package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.ProductType;
import iuh.fit.xstore.repository.ProductTypeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductTypeService {
    private final ProductTypeRepository productTypeRepository;
    
    public List<ProductType> findAll() {
        return productTypeRepository.findAll();
    }
    
    public ProductType findById(int id) {
        return productTypeRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_TYPE_NOT_FOUND));
    }
    
    public ProductType findByName(String name) {
        return productTypeRepository.findByName(name)
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_TYPE_NOT_FOUND));
    }
    
    public ProductType createProductType(ProductType productType) {
        if (productTypeRepository.existsByName(productType.getName())) {
            throw new AppException(ErrorCode.PRODUCT_TYPE_EXISTED);
        }
        return productTypeRepository.save(productType);
    }
    
    public ProductType updateProductType(ProductType productType) {
        ProductType existingType = productTypeRepository.findById(productType.getId())
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_TYPE_NOT_FOUND));
        
        existingType.setName(productType.getName());
        existingType.setDescription(productType.getDescription());
        
        return productTypeRepository.save(existingType);
    }
    
    public int deleteProductType(int id) {
        findById(id); // Check if product type exists
        productTypeRepository.deleteById(id);
        return id;
    }
}