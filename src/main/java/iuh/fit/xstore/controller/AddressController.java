package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Address;
import iuh.fit.xstore.service.AddressService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/addresses")
@AllArgsConstructor
public class AddressController {
    private final AddressService addressService;

    // GET /addresses: Lấy tất cả địa chỉ
    @GetMapping
    ApiResponse<List<Address>> getAddresses() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, addressService.findAll());
    }

    // GET /addresses/{id}: Lấy địa chỉ theo ID
    @GetMapping("/{id}")
    public ApiResponse<Address> getAddress(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, addressService.findById(id));
    }

    // POST /addresses: Tạo địa chỉ mới
    @PostMapping
    ApiResponse<Address> createAddress(@RequestBody Address address) {
        Address createdAddress = addressService.createAddress(address);
        // Tái sử dụng ACCOUNT_CREATED vì chưa có ADDRESS_CREATED (201) trong SuccessCode
        return new ApiResponse<>(SuccessCode.ADDRESS_CREATED, createdAddress);
    }

    // PUT /addresses/{id}: Cập nhật địa chỉ
    @PutMapping("/{id}")
    ApiResponse<Address> updateAddress(@PathVariable int id, @RequestBody Address address) {
        address.setId(id);
        Address updatedAddress = addressService.updateAddress(address);
        // Tái sử dụng ACCOUNT_UPDATED vì chưa có ADDRESS_UPDATED (200) trong SuccessCode
        return new ApiResponse<>(SuccessCode.ADDRESS_UPDATED, updatedAddress);
    }

    // DELETE /addresses/{id}: Xoá địa chỉ
    @DeleteMapping("/{id}")
    ApiResponse<Integer> deleteAddress(@PathVariable int id) {
        addressService.deleteAddress(id);
        // Tái sử dụng ACCOUNT_DELETED vì chưa có ADDRESS_DELETED (200) trong SuccessCode
        return new ApiResponse<>(SuccessCode.ADDRESS_DELETED, id);
    }
}