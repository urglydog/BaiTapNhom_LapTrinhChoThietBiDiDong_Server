package iuh.fit.movieapp.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * DataInitializer để xử lý duplicate movies và promotions khi server khởi động
 * Chạy sau khi data.sql được load để đảm bảo dữ liệu unique
 * - Movies: Xóa duplicate dựa trên title, giữ lại bản ghi có id nhỏ nhất
 * - Promotions: Xóa duplicate dựa trên code, giữ lại bản ghi có id nhỏ nhất
 */
@Slf4j
@Component
public class DataInitializer {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @EventListener(ApplicationReadyEvent.class)
    public void onApplicationReady() {
        try {
            log.info("Bắt đầu xử lý duplicate movies...");

            // Xóa các bản ghi duplicate movies, giữ lại bản ghi có id nhỏ nhất
            String deleteDuplicateMoviesSql = """
                    DELETE m1 FROM movies m1
                    INNER JOIN movies m2
                    WHERE m1.id > m2.id AND m1.title = m2.title
                    """;

            int deletedMoviesCount = jdbcTemplate.update(deleteDuplicateMoviesSql);

            if (deletedMoviesCount > 0) {
                log.info("Đã xóa {} bản ghi duplicate movies", deletedMoviesCount);
            } else {
                log.debug("Không có bản ghi duplicate movies nào");
            }

        } catch (Exception e) {
            log.error("Lỗi khi xử lý duplicate movies: {}", e.getMessage(), e);
            // Không throw exception để server vẫn có thể khởi động
        }

        try {
            log.info("Bắt đầu xử lý duplicate promotions...");

            // Xóa các bản ghi duplicate promotions, giữ lại bản ghi có id nhỏ nhất
            // Dựa trên code (unique field)
            String deleteDuplicatePromotionsSql = """
                    DELETE p1 FROM promotions p1
                    INNER JOIN promotions p2
                    WHERE p1.id > p2.id AND p1.code = p2.code
                    """;

            int deletedPromotionsCount = jdbcTemplate.update(deleteDuplicatePromotionsSql);

            if (deletedPromotionsCount > 0) {
                log.info("Đã xóa {} bản ghi duplicate promotions", deletedPromotionsCount);
            } else {
                log.debug("Không có bản ghi duplicate promotions nào");
            }

        } catch (Exception e) {
            log.error("Lỗi khi xử lý duplicate promotions: {}", e.getMessage(), e);
            // Không throw exception để server vẫn có thể khởi động
        }
    }
}
