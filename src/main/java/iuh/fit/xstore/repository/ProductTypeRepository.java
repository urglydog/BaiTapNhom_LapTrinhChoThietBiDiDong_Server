package iuh.fit.xstore.repository;

/*
 * Copyright (c) 2025 by tai
 * All rights reserved.
 *
 * Created: 10/22/2025
 */

import iuh.fit.xstore.model.ProductType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductTypeRepository extends JpaRepository<ProductType, Integer> {
    Optional<ProductType> findByName(String name);
    boolean existsByName(String name);
}