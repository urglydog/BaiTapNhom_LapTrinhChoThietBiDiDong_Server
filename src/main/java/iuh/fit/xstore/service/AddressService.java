package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Address;
import iuh.fit.xstore.repository.AddressRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AddressService {
    private final AddressRepository addressRepo;

    public List<Address> findAll() {
        return addressRepo.findAll();
    }

    public Address findById(int id) {
        return addressRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ADDRESS_NOT_FOUND));
    }

    public Address createAddress(Address address) {
        return addressRepo.save(address);
    }

    public Address updateAddress(Address address) {
        Address existedAddress = findById(address.getId());

        existedAddress.setNumOfHouse(address.getNumOfHouse());
        existedAddress.setStreet(address.getStreet());
        existedAddress.setCity(address.getCity());
        existedAddress.setCountry(address.getCountry());
        existedAddress.setFullAddress(address.getFullAddress());

        return addressRepo.save(existedAddress);
    }

    public int deleteAddress(int id) {
        findById(id);
        addressRepo.deleteById(id);
        return id;
    }
}