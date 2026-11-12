package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Category;

/**
 * Interface cho tầng DAO của Category
 * Tương ứng mục 2 trong Hướng dẫn CRUD với JPA3.0 và Jakarta 6.0
 */
public interface ICategoryDao {

    void insert(Category category);

    int count();

    List<Category> findAll(int page, int pagesize);

    List<Category> searchByName(String catname);

    List<Category> findAll();

    Category findById(int cateid);

    void delete(int cateid) throws Exception;

    void update(Category category);

    Category findByCategoryname(String name) throws Exception;
}

