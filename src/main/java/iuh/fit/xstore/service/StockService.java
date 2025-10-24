package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Stock;
import iuh.fit.xstore.model.StockItem;
import iuh.fit.xstore.repository.StockItemRepository;
import iuh.fit.xstore.repository.StockRepository;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import iuh.fit.xstore.repository.ProductRepository;
import iuh.fit.xstore.model.Product;
import java.util.List;

@Service
@AllArgsConstructor
public class StockService {
    private final StockRepository stockRepo;
    private final StockItemRepository stockItemRepo;
    private final ProductRepository productRepo;

    //Stock
    public List<Stock> findAll() {
        return stockRepo.findAll();
    }

    public Stock findById(int id) {
        return stockRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.STOCK_NOT_FOUND));
    }

    public Stock create(Stock stock) {
        return stockRepo.save(stock);
    }

    public Stock update(int id, Stock stock) {
        Stock s = findById(id);
        s.setName(stock.getName());
        s.setPhone(stock.getPhone());
        s.setEmail(stock.getEmail());
        s.setAddress(stock.getAddress());
        return stockRepo.save(s);
    }
    public int delete(int id) {
        Stock s = findById(id);
        try {
            stockRepo.delete(s);
        } catch (DataIntegrityViolationException ex) {
            // nếu còn hàng trong kho thì ko đc xóa kho
            throw new AppException(ErrorCode.STOCK_DELETE_FAILED);
        }
        return id;
    }
    //Stock Item
    public List<StockItem> getItemsOfStock(int id) {
        findById(id);
        return stockItemRepo.findByStock_Id(id);
    }


    public StockItem setItemQuantity(int id, int productId, int newQuantity) {
        //kiểm tra số lượng
        if (newQuantity < 0) throw new AppException(ErrorCode.INVALID_QUANTITY);

        Stock stock = findById(id);
        //tìm sp trong hệ thống
        Product product = productRepo.findById(productId)
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_NOT_FOUND));
        //tìm sản phẩm có trong kho chưa nếu chưa thì tạo mới
        StockItem item = stockItemRepo.findByStock_IdAndProduct_Id(id, productId)
                .orElseGet(() -> {
                    StockItem si = new StockItem();
                    si.setStock(stock);
                    si.setProduct(product);
                    si.setQuantity(0);
                    return si;
                });

        item.setQuantity(newQuantity);
        return stockItemRepo.save(item);
    }


    public StockItem increaseItemQuantity(int id, int productId, int amount) {
        if ( amount <= 0) throw new AppException(ErrorCode.INVALID_QUANTITY);

        StockItem item = stockItemRepo.findByStock_IdAndProduct_Id(id, productId)
                .orElseGet(() -> setItemQuantity(id, productId, 0));

        item.setQuantity(item.getQuantity() + amount);
        return stockItemRepo.save(item);
    }

    public StockItem decreaseItemQuantity(int id, int productId, int amount) {
        if ( amount <= 0) throw new AppException(ErrorCode.INVALID_QUANTITY);

        StockItem item = stockItemRepo.findByStock_IdAndProduct_Id(id, productId)
                .orElseThrow(() -> new AppException(ErrorCode.STOCK_ITEM_NOT_FOUND));

        int after = item.getQuantity() - amount;
        if (after < 0) throw new AppException(ErrorCode.NOT_ENOUGH_QUANTITY);

        item.setQuantity(after);
        return stockItemRepo.save(item);
    }
    // xóa sp khỏi kho
    public void deleteItem(int id, int productId) {
        StockItem item = stockItemRepo.findByStock_IdAndProduct_Id(id, productId)
                .orElseThrow(() -> new AppException(ErrorCode.STOCK_ITEM_NOT_FOUND));
        stockItemRepo.delete(item);
    }
}
