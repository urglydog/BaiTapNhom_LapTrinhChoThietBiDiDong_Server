package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/*
 * Copyright (c) 2025 by tai
 * All rights reserved.
 *
 * Created: 10/15/2025
 */
public interface AccountRepository extends JpaRepository<Account, Integer> {

    Optional<Account> findByUsername(String username);
}
