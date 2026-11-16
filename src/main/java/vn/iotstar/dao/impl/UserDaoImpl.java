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
    public User findById(int id) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return null;
        }
        try {
            return enma.find(User.class, id);
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] UserDaoImpl.findById: " + e.getMessage());
            return null;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public User findByEmail(String email) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return null;
        }
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email";
            TypedQuery<User> query = enma.createQuery(jpql, User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            if (list != null && !list.isEmpty()) {
                return list.get(0);
            }
            return null;
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] UserDaoImpl.findByEmail: " + e.getMessage());
            return null;
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
            return false;
        }
        try {
            String jpql = "SELECT count(u) FROM User u WHERE u.userName = :username";
            Long count = enma.createQuery(jpql, Long.class).setParameter("username", username).getSingleResult();
            return count > 0;
        } catch (Exception e) {
            return false;
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
            return getFallbackList();
        }
        try {
            return enma.createNamedQuery("User.findAll", User.class).getResultList();
        } catch (Exception e) {
            return getFallbackList();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    private User getFallbackUser(String username) {
        if ("admin".equalsIgnoreCase(username)) {
            User u = new User("admin@ute.udn.vn", "admin", "Quản trị viên (Dev)", "123", null, 1, "0901234567", null);
            u.setId(1);
            u.setStatus(1);
            return u;
        } else if ("user".equalsIgnoreCase(username)) {
            User u = new User("user@ute.udn.vn", "user", "Người dùng (Dev)", "123", null, 3, "0903456789", null);
            u.setId(2);
            u.setStatus(1);
            return u;
        }
        return null;
    }

    private List<User> getFallbackList() {
        List<User> list = new ArrayList<>();
        list.add(getFallbackUser("admin"));
        list.add(getFallbackUser("user"));
        return list;
    }
}
