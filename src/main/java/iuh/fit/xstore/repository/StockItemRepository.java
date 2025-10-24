package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.StockItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StockItemRepository extends JpaRepository<StockItem,Integer> {

    List<StockItem> findByStock_Id(int stockId);

    Optional<StockItem> findByStock_IdAndProduct_Id(int stockId, int productId);
}

