package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Cấu hình EntityManagerFactory cho JPA 3.0 & Hibernate
 * Tương ứng mục 4 trong tài liệu "Cấu hình và test JPA"
 */
public class JpaConfig {

    private static EntityManagerFactory factory;
    private static long lastAttemptTime = 0;
    private static final long RETRY_INTERVAL_MS = 15000; // 15 giây mới thử kết nối lại một lần nếu DB offline

    public static synchronized EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            long now = System.currentTimeMillis();
            if (now - lastAttemptTime < RETRY_INTERVAL_MS) {
                // Đang trong thời gian chờ sau khi kết nối thất bại, không chặn luồng nữa
                return null;
            }
            lastAttemptTime = now;
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
            } catch (Exception e) {
                System.err.println("[LỖI KẾT NỐI JPA] Không thể tạo EntityManagerFactory: " + e.getMessage());
                return null;
            }
        }
        try {
            return factory.createEntityManager();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] Không thể tạo EntityManager: " + e.getMessage());
            return null;
        }
    }

    public static synchronized boolean isDatabaseConnected() {
        return factory != null && factory.isOpen();
    }

    public static synchronized void close() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
