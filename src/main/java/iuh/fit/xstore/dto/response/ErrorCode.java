package iuh.fit.xstore.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ErrorCode {
//    === USER ===
    USER_NOT_FOUND(404, "User not found"),
    USER_EXISTED(409, "User already exists"),

//    === ACCOUNT ===
    ACCOUNT_NOT_FOUND(404, "Account not found"),
    ACCOUNT_EXISTED(409, "Account already exists"),
    USERNAME_NOT_FOUND(404, "Username not found"),
    USERNAME_EXISTED(409, "Username already exists"),
    PASSWORD_EMPTY(400, "Password cannot be empty"),
    INVALID_PASSWORD(401, "Invalid password"),
    INCORRECT_USERNAME_OR_PASSWORD(401, "Incorrect username or password"),

//    === PRODUCT ===
    PRODUCT_NOT_FOUND(404, "Product not found"),
    PRODUCT_EXISTED(409, "Product already exists"),
    PRODUCT_TYPE_NOT_FOUND(404, "Product type not found"),
    PRODUCT_TYPE_EXISTED(409, "Product type already exists"),

//    === ADDRESS ===
    ADDRESS_NOT_FOUND(404, "Address not found"),

//    === FAVOURITE ===
    FAVOURITE_EXISTED(409, "Favorite already exists"),
    FAVOURITE_NOT_FOUND(404, "Favorite not found"),

    // ===== ORDER =====
    ORDER_NOT_FOUND(404, "Order not found"),
    ORDER_EXISTED(409, "Order already exists"),
    INVALID_QUANTITY(409, "Invalid quantity"),

    // ===== ORDER ITEM =====
    ORDER_ITEM_NOT_FOUND(404, "Order item not found"),
    ORDER_ITEM_EXISTED(409, "Order item already exists"),
    TOKEN_EXPIRED(403, "Token has expired"),

    // === Discount Errors ===
    DISCOUNT_NOT_FOUND(404, "Discount not found"),
    DISCOUNT_EXISTED(409, "Discount already exists"),

//    === Stock ===
    STOCK_NOT_FOUND(404, "Stock not found"),
    STOCK_ITEM_NOT_FOUND(404, "Stock item not found"),
    NOT_ENOUGH_QUANTITY(409, "Not enough quantity"),
    STOCK_DELETE_FAILED(409, "Cannot delete stock while items remain"),

    UNKNOWN_ERROR(500, "Something went wrong");

    private final int code;
    private final String message;
}
