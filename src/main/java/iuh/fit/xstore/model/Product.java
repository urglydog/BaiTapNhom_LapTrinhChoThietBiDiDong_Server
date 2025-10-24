package iuh.fit.xstore.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Copyright (c) 2025 by Tai.
 * All rights reserved.
 * This file is part of X-Store.
 */

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@EqualsAndHashCode
@Builder

@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    private String description;
    private String image;

    @ManyToOne
    @JoinColumn(name="product_type_id")
    private ProductType type;
    private String brand;
    private Size size;
    private String color;
    private String fabric;

    @Column(name = "price_in_stock")
    private double priceInStock;
    private double price;

    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL)
    private List<OrderItem> orderItems = new ArrayList<>();
}
