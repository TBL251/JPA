package vn.iotstar.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener vòng đời ứng dụng web:
 * - Khởi tạo JPA ngầm ngay khi app deploy (giảm thời gian chờ request đầu tiên)
 * - Đóng EntityManagerFactory an toàn khi ứng dụng dừng
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Khởi động kết nối JPA nền ngầm
        JpaConfig.initAsync();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Giải phóng tài nguyên kết nối
        JpaConfig.close();
    }
}
