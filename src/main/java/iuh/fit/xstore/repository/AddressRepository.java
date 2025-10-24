package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AddressRepository extends JpaRepository<Address, Integer> {
}
