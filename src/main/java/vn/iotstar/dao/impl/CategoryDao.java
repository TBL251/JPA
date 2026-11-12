package vn.iotstar.dao.impl;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.ICategoryDao;
import vn.iotstar.entity.Category;

/**
 * Triển khai DAO Category bằng JPA 3.0 & Hibernate
 * Tương ứng mục 2 trong tài liệu Hướng dẫn CRUD với JPA3.0 và Jakarta 6.0
 */
public class CategoryDao implements ICategoryDao {

    @Override
    public void insert(Category category) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(category); // Thêm mới vào bảng categories
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void update(Category category) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(category); // Cập nhật vào bảng categories
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void delete(int cateid) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Category category = enma.find(Category.class, cateid);
            if (category != null) {
                enma.remove(category); // Xóa khỏi bảng categories
            } else {
                throw new Exception("Không tìm thấy Category với id = " + cateid);
            }
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public Category findById(int cateid) {
        try {
            EntityManager enma = JpaConfig.getEntityManager();
            try {
                return enma.find(Category.class, cateid);
            } finally {
                enma.close();
            }
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findById: " + e.getMessage());
            return null;
        }
    }

    @Override
    public Category findByCategoryname(String name) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        String jpql = "SELECT c FROM Category c WHERE c.categoryname = :catename";
        try {
            TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
            query.setParameter("catename", name);
            List<Category> list = query.getResultList();
            if (list == null || list.isEmpty()) {
                return null;
            }
            return list.get(0);
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Category> findAll() {
        try {
            EntityManager enma = JpaConfig.getEntityManager();
            try {
                TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
                return query.getResultList();
            } finally {
                enma.close();
            }
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findAll: " + e.getMessage());
            return getFallbackCategories();
        }
    }

    @Override
    public List<Category> searchByName(String catname) {
        try {
            EntityManager enma = JpaConfig.getEntityManager();
            String jpql = "SELECT c FROM Category c WHERE c.categoryname LIKE :catname";
            try {
                TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
                query.setParameter("catname", "%" + catname + "%");
                return query.getResultList();
            } finally {
                enma.close();
            }
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] searchByName: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    @Override
    public List<Category> findAll(int page, int pagesize) {
        try {
            EntityManager enma = JpaConfig.getEntityManager();
            try {
                TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
                query.setFirstResult(page * pagesize);
                query.setMaxResults(pagesize);
                return query.getResultList();
            } finally {
                enma.close();
            }
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findAll(page, pagesize): " + e.getMessage());
            return new ArrayList<>();
        }
    }

    @Override
    public int count() {
        try {
            EntityManager enma = JpaConfig.getEntityManager();
            String jpql = "SELECT count(c) FROM Category c";
            try {
                Query query = enma.createQuery(jpql);
                Object result = query.getSingleResult();
                return ((Number) result).intValue();
            } finally {
                enma.close();
            }
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] count: " + e.getMessage());
            return 0;
        }
    }

    private List<Category> getFallbackCategories() {
        List<Category> list = new ArrayList<>();
        list.add(new Category(1, "Điện thoại thông minh (Dữ liệu tạm)", "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300", 1));
        list.add(new Category(2, "Laptop & Máy tính xách tay (Dữ liệu tạm)", "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300", 1));
        list.add(new Category(3, "Phụ kiện công nghệ (Dữ liệu tạm)", "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300", 1));
        return list;
    }
}
