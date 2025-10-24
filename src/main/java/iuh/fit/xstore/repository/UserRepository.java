package iuh.fit.xstore.repository;

/*
 * Copyright (c) 2025 by tai
 * All rights reserved.
 *
 * Created: 10/15/2025
 */


import iuh.fit.xstore.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
   Optional<User> findByAccountUsername(String accountUsername);
    boolean existsByAccountUsername(String accountUsername);

    User getByAccountUsername(String accountUsername);
}
