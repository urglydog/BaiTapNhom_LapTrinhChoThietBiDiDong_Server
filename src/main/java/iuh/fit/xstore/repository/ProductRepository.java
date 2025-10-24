package iuh.fit.xstore.repository;

/*
 * Copyright (c) 2025 by tai
 * All rights reserved.
 *
 * Created: 10/22/2025
 */

import iuh.fit.xstore.model.Product;
import iuh.fit.xstore.model.ProductType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findByType(ProductType type);
    List<Product> findByTypeId(int typeId);
    List<Product> findByBrand(String brand);
    Optional<Product> findByName(String name);
    boolean existsByName(String name);
}