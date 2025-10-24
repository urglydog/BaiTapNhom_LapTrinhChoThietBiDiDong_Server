package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Account;
import iuh.fit.xstore.model.Role;
import iuh.fit.xstore.service.AccountService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/accounts")
@AllArgsConstructor
public class AccountController {
    private final AccountService accountService;

    // Lấy tất cả tài khoản
    @GetMapping
    ApiResponse<List<Account>> getAccounts() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, accountService.findAll());
    }

    // Lấy tài khoản theo ID
    @GetMapping("/{id}")
    ApiResponse<Account> getAccount(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, accountService.findById(id));
    }

    // Tạo tài khoản mới
    @PostMapping
    ApiResponse<Account> createAccount(@RequestBody Account account) {
        if (account.getRole() == null) {
            account.setRole(Role.CUSTOMER);
        }
        Account createdAccount = accountService.createAccount(account);
        return new ApiResponse<>(SuccessCode.ACCOUNT_CREATED, createdAccount);
    }

    // Cập nhật tài khoản
    @PutMapping("/{id}")
    ApiResponse<Account> updateAccount(@PathVariable int id, @RequestBody Account account) {
        account.setId(id);
        Account updatedAccount = accountService.updateAccount(account);
        return new ApiResponse<>(SuccessCode.ACCOUNT_UPDATED, updatedAccount);
    }

    // Xoá tài khoản theo ID
    @DeleteMapping("/{id}")
    ApiResponse<Integer> deleteAccount(@PathVariable int id) {
        accountService.deleteAccount(id);
        return new ApiResponse<>(SuccessCode.ACCOUNT_DELETED, id);
    }
}
