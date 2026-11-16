package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User;

public interface UserService {
    User login(String username, String password);

    User get(String username);

    User findById(int id);

    User findByEmail(String email);

    void insert(User user);

    void update(User user);

    boolean register(String username, String password, String email, String fullname, String phone, String otpCode);

    boolean verifyOtp(String emailOrUsername, String otpCode);

    boolean sendForgotPasswordOtp(String email);

    boolean resetPassword(String email, String otpCode, String newPassword);

    boolean checkExistEmail(String email);

    boolean checkExistUsername(String username);

    boolean checkExistPhone(String phone);

    List<User> findAll();
}
