package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Account;
import iuh.fit.xstore.repository.AccountRepository;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AccountService {
    private final PasswordEncoder passwordEncoder;
    private AccountRepository accountRepo;

    public List<Account> findAll() {
        return accountRepo.findAll();
    }

    public Account findById(int id) {
        return  accountRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_FOUND));
    }

    public Account findByUsername(String username) {
        return accountRepo.findByUsername((username))
                .orElseThrow(() -> new AppException(ErrorCode.ACCOUNT_NOT_FOUND));
    }

    public Account createAccount(Account account) {
        // check xem tai khoan co ton tai chua
        if (accountRepo.findByUsername(account.getUsername()).isPresent()) {
            throw new AppException(ErrorCode.ACCOUNT_EXISTED);
        }

        //check xem password co rong hay null khong
        if (account.getPassword() == null || account.getPassword().trim().isEmpty()) {
            throw new AppException(ErrorCode.PASSWORD_EMPTY);
        }

        account.setPassword(passwordEncoder.encode(account.getPassword()));
        return accountRepo.save(account);
    }

    public Account updateAccount(Account account) {
        Account existedAccount = findByUsername(account.getUsername());

        if (account.getPassword() == null || account.getPassword().trim().isEmpty()) {
            throw new AppException(ErrorCode.PASSWORD_EMPTY);
        }

        existedAccount.setPassword(passwordEncoder.encode(account.getPassword()));

        return accountRepo.save(existedAccount);
    }

    public int deleteAccount(int id) {
        findById(id);
        accountRepo.deleteById(id);
        return id;

    }
}
