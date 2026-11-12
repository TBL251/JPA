package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Category;

/**
 * Interface cho tầng Service của Category
 * Tương ứng mục 3 trong tài liệu Hướng dẫn CRUD với JPA3.0 và Jakarta 6.0
 */
public interface ICategoryService {

    void insert(Category category);

    int count();

    List<Category> findAll(int page, int pagesize);

    List<Category> searchByName(String catname);

    List<Category> findAll();

    Category findById(int cateid);

    void delete(int cateid) throws Exception;

    void update(Category category);

    Category findByCategoryname(String name);
}

