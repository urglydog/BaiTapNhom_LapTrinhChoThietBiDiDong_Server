package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Order;
import iuh.fit.xstore.model.OrderItem;
import iuh.fit.xstore.repository.OrderItemRepository;
import iuh.fit.xstore.repository.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class OrderService {
    private final OrderRepository orderRepo;
    private final OrderItemRepository orderItemRepo;

    public List<Order> findAllOrders() {
        return orderRepo.findAll();
    }

    public Order findOrderById(int id) {
        return orderRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ORDER_NOT_FOUND));
    }

    public Order createOrder(Order order) {
        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            double total = order.getOrderItems()
                    .stream()
                    .mapToDouble(OrderItem::getSubTotal)
                    .sum();
            order.setTotal(total);

            // Gán quan hệ hai chiều để tránh lỗi transient
            order.getOrderItems().forEach(item -> item.setOrder(order));
        }
        return orderRepo.save(order);
    }

    public Order updateOrder(int id, Order order) {
        Order existed = findOrderById(id);
        existed.setStatus(order.getStatus());
        existed.setTotal(order.getTotal());

        if (order.getOrderItems() != null) {
            // Clear list cũ rồi add list mới để không lỗi orphan
            existed.getOrderItems().clear();
            order.getOrderItems().forEach(item -> item.setOrder(existed));
            existed.getOrderItems().addAll(order.getOrderItems());

            // Tính lại tổng tiền
            double total = existed.getOrderItems()
                    .stream()
                    .mapToDouble(OrderItem::getSubTotal)
                    .sum();
            existed.setTotal(total);
        }

        return orderRepo.save(existed);
    }

    public int deleteOrder(int id) {
        findOrderById(id);
        orderRepo.deleteById(id);
        return id;
    }

    public List<OrderItem> findAllOrderItems() {
        return orderItemRepo.findAll();
    }

    public OrderItem findOrderItemById(int id) {
        return orderItemRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ORDER_ITEM_NOT_FOUND));
    }

    public OrderItem createOrderItem(OrderItem item) {
        if (item.getQuantity() <= 0) {
            throw new AppException(ErrorCode.INVALID_QUANTITY);
        }

        if (item.getOrder() == null || item.getOrder().getId() == 0) {
            throw new AppException(ErrorCode.ORDER_NOT_FOUND);
        }

        item.setSubTotal(item.getProduct().getPrice() * item.getQuantity());
        return orderItemRepo.save(item);
    }

    public OrderItem updateOrderItem(int id, OrderItem item) {
        OrderItem existed = findOrderItemById(id);
        existed.setQuantity(item.getQuantity());
        existed.setSubTotal(item.getProduct().getPrice() * item.getQuantity());
        existed.setProduct(item.getProduct());
        existed.setOrder(item.getOrder());
        return orderItemRepo.save(existed);
    }

    public int deleteOrderItem(int id) {
        findOrderItemById(id);
        orderItemRepo.deleteById(id);
        return id;
    }
}
