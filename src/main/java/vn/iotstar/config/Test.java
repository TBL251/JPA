package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;

/**
 * Lớp Test cấu hình JPA và Hibernate
 * Tương ứng mục 5 trong tài liệu "Cấu hình và test JPA"
 */
public class Test {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println("   BAT DAU KIEM TRA KET NOI VA THAO TAC VOI JPA   ");
        System.out.println("==================================================");

        EntityManager enma = null;
        EntityTransaction trans = null;

        try {
            enma = JpaConfig.getEntityManager();
            trans = enma.getTransaction();

            Category cate = new Category();
            cate.setCategoryname("Iphone");
            cate.setImages("abc.jpg");
            cate.setStatus(1);

            Video video = new Video();
            video.setVideoId("v01");
            video.setTitle("test");
            video.setCategory(cate);

            trans.begin();
            enma.persist(cate);
            enma.persist(video);
            trans.commit();

            System.out.println(">>> SUCCESS: Da them thanh cong Category: " + cate.getCategoryname() + " (ID: "
                    + cate.getCategoryId() + ") va Video: " + video.getVideoId() + " vao CSDL!");
        } catch (Exception e) {
            if (trans != null && trans.isActive()) {
                trans.rollback();
            }
            System.err.println(">>> LOI TRONG QUA TRINH THUC THI JPA:");
            e.printStackTrace();
        } finally {
            if (enma != null && enma.isOpen()) {
                enma.close();
            }
            JpaConfig.close();
            System.out.println("==================================================");
            System.out.println("   HOAN TAT QUA TRINH TEST JPA                    ");
            System.out.println("==================================================");
        }
    }
}

