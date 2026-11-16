package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.User;

public interface UserDao {
    User get(String username);
    User findById(int id);
    User findByEmail(String email);
    void insert(User user);
    void update(User user);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    List<User> findAll();
}
