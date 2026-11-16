package vn.iotstar.service.impl;

import java.sql.Date;
import java.util.List;

import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements UserService {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        User user = this.get(username);
        if (user == null) {
            // Thử tìm theo email nếu người dùng nhập email vào ô đăng nhập
            user = this.findByEmail(username);
        }
        if (user != null && PasswordUtil.checkPassword(password, user.getPassWord())) {
            return user;
        }
        return null;
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone, String otpCode) {
        if (checkExistUsername(username) || (email != null && !email.trim().isEmpty() && checkExistEmail(email))) {
            return false;
        }
        User user = new User();
        user.setUserName(username);
        // Mã hóa mật khẩu với BCrypt
        user.setPassWord(PasswordUtil.hashPassword(password));
        user.setEmail(email);
        user.setFullName(fullname);
        user.setPhone(phone);
        user.setRoleid(3); // Quyền người dùng mặc định
        user.setStatus(0); // Chưa kích hoạt tài khoản, cần nhập mã OTP
        user.setCode(otpCode); // Lưu mã OTP 6 số
        user.setCreatedDate(new Date(System.currentTimeMillis()));

        userDao.insert(user);

        // Gửi email chứa mã OTP kích hoạt tài khoản
        EmailUtil.sendOtpEmail(email, otpCode, "[HCMUTE] Mã OTP kích hoạt tài khoản của bạn", "KÍCH HOẠT TÀI KHOẢN MỚI");
        return true;
    }

    @Override
    public boolean verifyOtp(String emailOrUsername, String otpCode) {
        if (emailOrUsername == null || otpCode == null) {
            return false;
        }
        User user = this.findByEmail(emailOrUsername.trim());
        if (user == null) {
            user = this.get(emailOrUsername.trim());
        }
        if (user != null && otpCode.trim().equals(user.getCode())) {
            user.setStatus(1); // Kích hoạt tài khoản thành công
            user.setCode(null); // Xóa mã OTP sau khi sử dụng
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean sendForgotPasswordOtp(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        User user = this.findByEmail(email.trim());
        if (user == null) {
            user = this.get(email.trim());
        }
        if (user != null) {
            String otpCode = EmailUtil.generateOtp();
            user.setCode(otpCode);
            userDao.update(user);
            EmailUtil.sendOtpEmail(user.getEmail(), otpCode, "[HCMUTE] Mã OTP đặt lại mật khẩu của bạn", "QUÊN MẬT KHẨU");
            return true;
        }
        return false;
    }

    @Override
    public boolean resetPassword(String email, String otpCode, String newPassword) {
        if (email == null || otpCode == null || newPassword == null) {
            return false;
        }
        User user = this.findByEmail(email.trim());
        if (user == null) {
            user = this.get(email.trim());
        }
        if (user != null && otpCode.trim().equals(user.getCode())) {
            user.setPassWord(PasswordUtil.hashPassword(newPassword));
            user.setCode(null); // Xóa mã OTP sau khi đổi mật khẩu
            userDao.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public List<User> findAll() {
        return userDao.findAll();
    }
}
