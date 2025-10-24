package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Stock;
import iuh.fit.xstore.model.StockItem;
import iuh.fit.xstore.service.StockService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/stocks")
@AllArgsConstructor
public class StockController {

    private final StockService stockService;

    // Stock
    @GetMapping
    ApiResponse<List<Stock>> getStocks() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, stockService.findAll());
    }

    @GetMapping("/{id}")
    ApiResponse<Stock> getStock(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, stockService.findById(id));
    }

    @PostMapping
    ApiResponse<Stock> createStock(@RequestBody Stock stock) {
        return new ApiResponse<>(SuccessCode.STOCK_CREATED, stockService.create(stock));
    }

    @PutMapping("/{id}")
    ApiResponse<Stock> updateStock(@PathVariable int id, @RequestBody Stock stock) {
        return new ApiResponse<>(SuccessCode.STOCK_UPDATED, stockService.update(id, stock));
    }

    @DeleteMapping("/{id}")
    ApiResponse<Integer> deleteStock(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.STOCK_DELETED, stockService.delete(id));
    }

    //Stock item
    // Xem danh sách sản phẩm trong kho
    @GetMapping("/{id}/items")
    ApiResponse<List<StockItem>> getItems(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, stockService.getItemsOfStock(id));
    }

    // Tạo mới hoặc cập nhật số lượng
    @PostMapping("/{id}/items")
    ApiResponse<StockItem> setItemQuantity(@PathVariable int id,
                                           @RequestParam int productId,
                                           @RequestParam int quantity) {
        return new ApiResponse<>(SuccessCode.STOCK_ITEM_UPDATED,
                stockService.setItemQuantity(id, productId, quantity));
    }

    // Tăng số lượng
    @PostMapping("/{id}/items/increase")
    ApiResponse<StockItem> increaseItemQuantity(@PathVariable int id,
                                                @RequestParam int productId,
                                                @RequestParam int amount) {
        return new ApiResponse<>(SuccessCode.STOCK_ITEM_UPDATED,
                stockService.increaseItemQuantity(id, productId, amount));
    }

    // Giảm số lượng
    @PostMapping("/{id}/items/decrease")
    ApiResponse<StockItem> decreaseItemQuantity(@PathVariable int id,
                                                @RequestParam int productId,
                                                @RequestParam int amount) {
        return new ApiResponse<>(SuccessCode.STOCK_ITEM_UPDATED,
                stockService.decreaseItemQuantity(id, productId, amount));
    }

    // Xóa sản phẩm khỏi kho
    @DeleteMapping("/{id}/items")
    ApiResponse<Void> deleteItem(@PathVariable int id,
                                 @RequestParam int productId) {
        stockService.deleteItem(id, productId);
        return new ApiResponse<>(SuccessCode.STOCK_ITEM_DELETED, null);
    }
}
