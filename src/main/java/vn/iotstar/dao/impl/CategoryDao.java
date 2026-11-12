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
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] insert: Cơ sở dữ liệu đang ngoại tuyến.");
            return;
        }
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
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public void update(Category category) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] update: Cơ sở dữ liệu đang ngoại tuyến.");
            return;
        }
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
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public void delete(int cateid) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] delete: Cơ sở dữ liệu đang ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Category category = enma.find(Category.class, cateid);
            if (category != null) {
                enma.remove(category); // Xóa khỏi bảng categories
            } else {
                throw new Exception("Không tìm thấy Category với ID: " + cateid);
            }
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public Category findById(int cateid) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            for (Category c : getFallbackCategories()) {
                if (c.getCategoryId() == cateid) return c;
            }
            return null;
        }
        try {
            return enma.find(Category.class, cateid);
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findById: " + e.getMessage());
            return null;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public Category findByCategoryname(String name) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            for (Category c : getFallbackCategories()) {
                if (c.getCategoryname().equalsIgnoreCase(name)) return c;
            }
            return null;
        }
        String jpql = "SELECT c FROM Category c WHERE c.categoryname = :catename";
        try {
            TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
            query.setParameter("catename", name);
            List<Category> list = query.getResultList();
            if (list == null || list.isEmpty()) {
                return null;
            }
            return list.get(0);
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findByCategoryname: " + e.getMessage());
            return null;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Category> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackCategories();
        }
        try {
            TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findAll: " + e.getMessage());
            return getFallbackCategories();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Category> searchByName(String catname) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            List<Category> matched = new ArrayList<>();
            for (Category c : getFallbackCategories()) {
                if (c.getCategoryname().toLowerCase().contains(catname.toLowerCase())) {
                    matched.add(c);
                }
            }
            return matched;
        }
        String jpql = "SELECT c FROM Category c WHERE c.categoryname LIKE :catname";
        try {
            TypedQuery<Category> query = enma.createQuery(jpql, Category.class);
            query.setParameter("catname", "%" + catname + "%");
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] searchByName: " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Category> findAll(int page, int pagesize) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackCategories();
        }
        try {
            TypedQuery<Category> query = enma.createNamedQuery("Category.findAll", Category.class);
            query.setFirstResult(page * pagesize);
            query.setMaxResults(pagesize);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findAll(page, pagesize): " + e.getMessage());
            return new ArrayList<>();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public int count() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackCategories().size();
        }
        String jpql = "SELECT count(c) FROM Category c";
        try {
            Query query = enma.createQuery(jpql);
            Object result = query.getSingleResult();
            return ((Number) result).intValue();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] count: " + e.getMessage());
            return 0;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
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
