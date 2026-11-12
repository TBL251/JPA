package vn.iotstar.config;

import jakarta.persistence.EntityManager;

/**
 * Lớp tương thích với tên gọi JPAConfig trong tài liệu Hướng dẫn CRUD với JPA3.0
 */
public class JPAConfig extends JpaConfig {

    public static EntityManager getEntityManager() {
        return JpaConfig.getEntityManager();
    }
}
