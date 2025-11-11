package iuh.fit.movieapp.config;

import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * DataInitializer để xử lý duplicate movies khi server khởi động
 * Chạy sau khi data.sql được load để đảm bảo dữ liệu unique
 */
@Slf4j
@Component
public class DataInitializer {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @EventListener(ApplicationReadyEvent.class)
    @Transactional
    public void onApplicationReady() {
        try {
            log.info("Bắt đầu xử lý duplicate movies...");

            // Xóa các bản ghi duplicate, giữ lại bản ghi có id nhỏ nhất
            String deleteDuplicateSql = """
                    DELETE m1 FROM movies m1
                    INNER JOIN movies m2
                    WHERE m1.id > m2.id AND m1.title = m2.title
                    """;

            int deletedCount = jdbcTemplate.update(deleteDuplicateSql);

            if (deletedCount > 0) {
                log.info("Đã xóa {} bản ghi duplicate movies", deletedCount);
            } else {
                log.debug("Không có bản ghi duplicate nào");
            }

        } catch (Exception e) {
            log.error("Lỗi khi xử lý duplicate movies: {}", e.getMessage(), e);
            // Không throw exception để server vẫn có thể khởi động
        }
    }
}
