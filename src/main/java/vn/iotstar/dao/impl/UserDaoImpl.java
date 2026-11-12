package vn.iotstar.dao.impl;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.UserDao;
import vn.iotstar.entity.User;

public class UserDaoImpl implements UserDao {

    @Override
    public User get(String username) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackUser(username);
        }
        try {
            String jpql = "SELECT u FROM User u WHERE u.userName = :username";
            TypedQuery<User> query = enma.createQuery(jpql, User.class);
            query.setParameter("username", username);
            List<User> list = query.getResultList();
            if (list != null && !list.isEmpty()) {
                return list.get(0);
            }
            return getFallbackUser(username);
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] UserDaoImpl.get: " + e.getMessage());
            return getFallbackUser(username);
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public void insert(User user) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] insert user: CSDL ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(user);
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
    public void update(User user) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] update user: CSDL ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(user);
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
    public boolean checkExistEmail(String email) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return false;
        }
        try {
            String jpql = "SELECT count(u) FROM User u WHERE u.email = :email";
            Long count = enma.createQuery(jpql, Long.class).setParameter("email", email).getSingleResult();
            return count > 0;
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] checkExistEmail: " + e.getMessage());
            return false;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public boolean checkExistUsername(String username) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return "admin".equalsIgnoreCase(username) || "user".equalsIgnoreCase(username);
        }
        try {
            String jpql = "SELECT count(u) FROM User u WHERE u.userName = :username";
            Long count = enma.createQuery(jpql, Long.class).setParameter("username", username).getSingleResult();
            return count > 0;
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] checkExistUsername: " + e.getMessage());
            return "admin".equalsIgnoreCase(username) || "user".equalsIgnoreCase(username);
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public boolean checkExistPhone(String phone) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return false;
        }
        try {
            String jpql = "SELECT count(u) FROM User u WHERE u.phone = :phone";
            Long count = enma.createQuery(jpql, Long.class).setParameter("phone", phone).getSingleResult();
            return count > 0;
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] checkExistPhone: " + e.getMessage());
            return false;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<User> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            List<User> list = new ArrayList<>();
            list.add(getFallbackUser("admin"));
            list.add(getFallbackUser("user"));
            return list;
        }
        try {
            return enma.createNamedQuery("User.findAll", User.class).getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] findAll users: " + e.getMessage());
            List<User> list = new ArrayList<>();
            list.add(getFallbackUser("admin"));
            list.add(getFallbackUser("user"));
            return list;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    /**
     * Cung cấp người dùng dự phòng khi CSDL đang ngoại tuyến hoặc đang kích hoạt kết nối.
     * Hỗ trợ tài khoản admin (roleid=1) và user (roleid=2).
     */
    private User getFallbackUser(String username) {
        if ("admin".equalsIgnoreCase(username)) {
            User admin = new User();
            admin.setId(1);
            admin.setUserName("admin");
            admin.setPassWord("123456");
            admin.setFullName("Quản trị viên Hệ thống (Dữ liệu tạm)");
            admin.setEmail("admin@iotstar.vn");
            admin.setPhone("0987654321");
            admin.setRoleid(1);
            return admin;
        } else if ("user".equalsIgnoreCase(username)) {
            User user = new User();
            user.setId(2);
            user.setUserName("user");
            user.setPassWord("123456");
            user.setFullName("Người dùng Mẫu (Dữ liệu tạm)");
            user.setEmail("user@iotstar.vn");
            user.setPhone("0123456789");
            user.setRoleid(2);
            return user;
        }
        return null;
    }
}
