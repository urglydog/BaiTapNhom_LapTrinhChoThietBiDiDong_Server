package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Order;
import iuh.fit.xstore.model.OrderItem;
import iuh.fit.xstore.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
public class OrderController {
    private final OrderService orderService;

    // ========== ORDER ==========
    @GetMapping
    public ApiResponse<List<Order>> getAllOrders() {
        var orders = orderService.findAllOrders();
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS.getCode(),
                SuccessCode.FETCH_SUCCESS.getMessage(), orders);
    }

    @GetMapping("/{id}")
    public ApiResponse<Order> getOrderById(@PathVariable int id) {
        var order = orderService.findOrderById(id);
        if (order == null)
            return new ApiResponse<>(ErrorCode.ORDER_NOT_FOUND.getCode(),
                    ErrorCode.ORDER_NOT_FOUND.getMessage(), null);
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS.getCode(),
                SuccessCode.FETCH_SUCCESS.getMessage(), order);
    }

    @PostMapping
    public ApiResponse<Order> createOrder(@RequestBody Order order) {
        var created = orderService.createOrder(order);
        return new ApiResponse<>(SuccessCode.ORDER_CREATED.getCode(),
                SuccessCode.ORDER_CREATED.getMessage(), created);
    }

    @PutMapping("/{id}")
    public ApiResponse<Order> updateOrder(@PathVariable int id, @RequestBody Order order) {
        var updated = orderService.updateOrder(id, order);
        if (updated == null)
            return new ApiResponse<>(ErrorCode.ORDER_NOT_FOUND.getCode(),
                    ErrorCode.ORDER_NOT_FOUND.getMessage(), null);
        return new ApiResponse<>(SuccessCode.ORDER_UPDATED.getCode(),
                SuccessCode.ORDER_UPDATED.getMessage(), updated);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Integer> deleteOrder(@PathVariable int id) {
        var deletedId = orderService.deleteOrder(id);
        return new ApiResponse<>(SuccessCode.ORDER_DELETED.getCode(),
                SuccessCode.ORDER_DELETED.getMessage(), deletedId);
    }

    // ========== ORDER ITEM ==========
    @GetMapping("/items")
    public ApiResponse<List<OrderItem>> getAllOrderItems() {
        var items = orderService.findAllOrderItems();
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS.getCode(),
                SuccessCode.FETCH_SUCCESS.getMessage(), items);
    }

    @GetMapping("/items/{id}")
    public ApiResponse<OrderItem> getOrderItemById(@PathVariable int id) {
        var item = orderService.findOrderItemById(id);
        if (item == null)
            return new ApiResponse<>(ErrorCode.ORDER_ITEM_NOT_FOUND.getCode(),
                    ErrorCode.ORDER_ITEM_NOT_FOUND.getMessage(), null);
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS.getCode(),
                SuccessCode.FETCH_SUCCESS.getMessage(), item);
    }

    @PostMapping("/items")
    public ApiResponse<OrderItem> createOrderItem(@RequestBody OrderItem item) {
        var created = orderService.createOrderItem(item);
        return new ApiResponse<>(SuccessCode.ORDER_ITEM_CREATED.getCode(),
                SuccessCode.ORDER_ITEM_CREATED.getMessage(), created);
    }

    @PutMapping("/items/{id}")
    public ApiResponse<OrderItem> updateOrderItem(@PathVariable int id, @RequestBody OrderItem item) {
        var updated = orderService.updateOrderItem(id, item);
        if (updated == null)
            return new ApiResponse<>(ErrorCode.ORDER_ITEM_NOT_FOUND.getCode(),
                    ErrorCode.ORDER_ITEM_NOT_FOUND.getMessage(), null);
        return new ApiResponse<>(SuccessCode.ORDER_ITEM_UPDATED.getCode(),
                SuccessCode.ORDER_ITEM_UPDATED.getMessage(), updated);
    }

    @DeleteMapping("/items/{id}")
    public ApiResponse<Integer> deleteOrderItem(@PathVariable int id) {
        var deletedId = orderService.deleteOrderItem(id);
        return new ApiResponse<>(SuccessCode.ORDER_ITEM_DELETED.getCode(),
                SuccessCode.ORDER_ITEM_DELETED.getMessage(), deletedId);
    }
}
