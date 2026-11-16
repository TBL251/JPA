package vn.iotstar.dao.impl;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.entity.Video;

public class VideoDaoImpl implements IVideoDao {

    @Override
    public int count() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackVideos().size();
        }
        try {
            String jpql = "SELECT count(v) FROM Video v";
            Long count = enma.createQuery(jpql, Long.class).getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.count: " + e.getMessage());
            return getFallbackVideos().size();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackVideos();
        }
        try {
            TypedQuery<Video> query = enma.createNamedQuery("Video.findAll", Video.class);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.findAll: " + e.getMessage());
            return getFallbackVideos();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Video> findAll(int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackVideos();
        }
        try {
            TypedQuery<Video> query = enma.createNamedQuery("Video.findAll", Video.class);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.findAll(page): " + e.getMessage());
            return getFallbackVideos();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public Video findById(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            for (Video v : getFallbackVideos()) {
                if (v.getVideoId().equalsIgnoreCase(videoId)) {
                    return v;
                }
            }
            return null;
        }
        try {
            return enma.find(Video.class, videoId);
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.findById: " + e.getMessage());
            for (Video v : getFallbackVideos()) {
                if (v.getVideoId().equalsIgnoreCase(videoId)) {
                    return v;
                }
            }
            return null;
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public void insert(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] insert video: CSDL ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(video);
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
    public void update(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] update video: CSDL ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(video);
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
    public void delete(String videoId) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            System.err.println("[LỖI KẾT NỐI JPA] delete video: CSDL ngoại tuyến.");
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                enma.remove(video);
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
    public List<Video> findTop10Latest() {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            List<Video> fallback = getFallbackVideos();
            return fallback.subList(0, Math.min(10, fallback.size()));
        }
        try {
            String jpql = "SELECT v FROM Video v WHERE v.active = true ORDER BY v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setMaxResults(10);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.findTop10Latest: " + e.getMessage());
            List<Video> fallback = getFallbackVideos();
            return fallback.subList(0, Math.min(10, fallback.size()));
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackVideos();
        }
        try {
            String jpql = "SELECT v FROM Video v WHERE v.user.id = :userId ORDER BY v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            query.setFirstResult((page - 1) * pageSize);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.findByUserId: " + e.getMessage());
            return getFallbackVideos();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public int countByUserId(int userId) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return getFallbackVideos().size();
        }
        try {
            String jpql = "SELECT count(v) FROM Video v WHERE v.user.id = :userId";
            Long count = enma.createQuery(jpql, Long.class).setParameter("userId", userId).getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            System.err.println("[LỖI KẾT NỐI JPA] VideoDaoImpl.countByUserId: " + e.getMessage());
            return getFallbackVideos().size();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    @Override
    public void increaseViews(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        if (enma == null) {
            return;
        }
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                video.setViews(video.getViews() + 1);
                enma.merge(video);
            }
            trans.commit();
        } catch (Exception e) {
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
        }
    }

    private List<Video> getFallbackVideos() {
        List<Video> list = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            Video v = new Video();
            v.setVideoId("v" + String.format("%02d", i));
            v.setTitle("Video Bài Giảng Số " + i + " - Lập Trình Web HCMUTE");
            v.setDescription("Nội dung hướng dẫn chi tiết kiến trúc Java Web Servlet, JSP, Hibernate JPA 3.0 và kết nối SQL Server.");
            v.setPoster("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600");
            v.setViews(100 * i);
            v.setActive(true);
            list.add(v);
        }
        return list;
    }
}
