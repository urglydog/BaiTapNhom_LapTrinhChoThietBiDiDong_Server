package iuh.fit.xstore.model;

import jakarta.persistence.Entity;

public enum OrderStatus {
    IN_TRANSIT,          // Đang giao hàng
    PENDING_RECEIPT,     // Chờ nhận hàng
    DELIVERED,           // Đã giao hàng
    CANCELLED,           // Đã hủy
    RETURN_REQUESTED     // Yêu cầu đổi/trả
}
