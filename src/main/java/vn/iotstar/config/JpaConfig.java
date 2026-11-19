package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Cấu hình EntityManagerFactory cho JPA 3.0 & Hibernate
 * Tối ưu hóa: Warmup bất đồng bộ (Async Warmup) và bảo vệ luồng HTTP không bị nghẽn (Non-blocking)
 */
public class JpaConfig {

    private static volatile EntityManagerFactory factory;
    private static volatile boolean isInitializing = false;
    private static volatile long lastAttemptTime = 0;
    private static final long RETRY_INTERVAL_MS = 15000; // 15 giây mới thử kết nối lại một lần nếu DB offline

    /**
     * Khởi tạo EntityManagerFactory ngầm trong background thread khi server khởi động
     * Giúp các request đầu tiên không bị block hàng giây để chờ kết nối CSDL
     */
    public static void initAsync() {
        if (factory == null && !isInitializing) {
            isInitializing = true;
            Thread warmupThread = new Thread(() -> {
                try {
                    factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
                } catch (Exception e) {
                    System.err.println("[LỖI KẾT NỐI JPA] Không thể tạo EntityManagerFactory (Warmup): " + e.getMessage());
                } finally {
                    isInitializing = false;
                    lastAttemptTime = System.currentTimeMillis();
                }
            }, "JPA-Warmup-Thread");
            warmupThread.setDaemon(true);
            warmupThread.start();
        }
    }

    public static EntityManager getEntityManager() {
        if (factory == null || !factory.isOpen()) {
            if (isInitializing) {
                // Đang trong tiến trình khởi tạo ngầm, trả về null ngay để giao diện tải tức thì
                return null;
            }
            long now = System.currentTimeMillis();
            if (now - lastAttemptTime < RETRY_INTERVAL_MS) {
                // Đang trong thời gian chờ sau khi kết nối thất bại, không chặn luồng nữa
                return null;
            }
            lastAttemptTime = now;
            isInitializing = true;
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
            } catch (Exception e) {
                System.err.println("[LỖI KẾT NỐI JPA] Không thể tạo EntityManagerFactory: " + e.getMessage());
                return null;
            } finally {
                isInitializing = false;
            }
        }
        try {
            return factory.createEntityManager();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] Không thể tạo EntityManager: " + e.getMessage());
            return null;
        }
    }

    public static boolean isDatabaseConnected() {
        return factory != null && factory.isOpen();
    }

    public static synchronized void close() {
        if (factory != null && factory.isOpen()) {
            factory.close();
            factory = null;
        }
    }
}
