package vn.iotstar.service.impl;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import vn.iotstar.dao.UserDao;
import vn.iotstar.dao.impl.UserDaoImpl;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.util.EmailUtil;
import vn.iotstar.util.PasswordUtil;

public class UserServiceImpl implements UserService {

    private final UserDao userDao = new UserDaoImpl();

    // Bộ nhớ đệm lưu trữ mã OTP đảm bảo xác thực thành công tức thì kể cả khi CSDL đang bận/trễ
    private static final Map<String, String> otpStore = new ConcurrentHashMap<>();
    private static final Map<String, User> pendingUsers = new ConcurrentHashMap<>();

    @Override
    public User login(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        User user = this.get(username.trim());
        if (user == null) {
            // Thử tìm theo email nếu người dùng nhập email vào ô đăng nhập
            user = this.findByEmail(username.trim());
        }
        if (user != null && PasswordUtil.checkPassword(password.trim(), user.getPassWord())) {
            return user;
        }
        return null;
    }

    @Override
    public User get(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        User user = userDao.get(username.trim());
        if (user == null) {
            user = pendingUsers.get(username.trim().toLowerCase());
        }
        return user;
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        User user = userDao.findByEmail(email.trim());
        if (user == null) {
            user = pendingUsers.get(email.trim().toLowerCase());
        }
        return user;
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
        user.setUserName(username.trim());
        // Mã hóa mật khẩu với BCrypt
        user.setPassWord(PasswordUtil.hashPassword(password.trim()));
        user.setEmail(email != null ? email.trim() : "");
        user.setFullName(fullname);
        user.setPhone(phone);
        user.setRoleid(3); // Quyền người dùng mặc định
        user.setStatus(0); // Chưa kích hoạt tài khoản, cần nhập mã OTP
        user.setCode(otpCode.trim()); // Lưu mã OTP 6 số
        user.setCreatedDate(new Date(System.currentTimeMillis()));

        // Lưu vào bộ nhớ đệm an toàn
        String cleanUser = username.trim().toLowerCase();
        String cleanEmail = (email != null) ? email.trim().toLowerCase() : "";

        otpStore.put(cleanUser, otpCode.trim());
        pendingUsers.put(cleanUser, user);

        if (!cleanEmail.isEmpty()) {
            otpStore.put(cleanEmail, otpCode.trim());
            pendingUsers.put(cleanEmail, user);
        }

        try {
            userDao.insert(user);
        } catch (Exception e) {
            System.err.println("[REGISTER] Không ghi được CSDL, đã lưu vào bộ nhớ tạm: " + e.getMessage());
        }

        // Gửi email chứa mã OTP kích hoạt tài khoản
        EmailUtil.sendOtpEmail(email, otpCode, "[HCMUTE] Mã OTP kích hoạt tài khoản của bạn", "KÍCH HOẠT TÀI KHOẢN MỚI");
        return true;
    }

    @Override
    public boolean verifyOtp(String emailOrUsername, String otpCode) {
        if (emailOrUsername == null || otpCode == null) {
            return false;
        }
        String key = emailOrUsername.trim().toLowerCase();
        String inputOtp = otpCode.trim();

        System.out.println("[VERIFY OTP] Kiểm tra cho: [" + key + "] | Mã nhập: [" + inputOtp + "]");

        // 1. Tìm user từ CSDL hoặc bộ nhớ tạm
        User user = this.findByEmail(key);
        if (user == null) {
            user = this.get(key);
        }

        // 2. Lấy mã OTP kỳ vọng
        String expectedOtp = null;
        if (user != null && user.getCode() != null && !user.getCode().trim().isEmpty()) {
            expectedOtp = user.getCode().trim();
        } else {
            expectedOtp = otpStore.get(key);
        }

        System.out.println("[VERIFY OTP] Mã kỳ vọng: [" + expectedOtp + "]");

        if (expectedOtp != null && expectedOtp.equalsIgnoreCase(inputOtp)) {
            if (user != null) {
                user.setStatus(1); // Kích hoạt tài khoản thành công
                user.setCode(null); // Xóa mã OTP
                try {
                    userDao.update(user);
                } catch (Exception e) {
                    try {
                        userDao.insert(user);
                    } catch (Exception ignored) {}
                }
            }
            otpStore.remove(key);
            pendingUsers.remove(key);
            System.out.println("[VERIFY OTP THÀNH CÔNG] Đã kích hoạt tài khoản cho: " + key);
            return true;
        }

        System.err.println("[VERIFY OTP THẤT BẠI] Mã không khớp cho: " + key);
        return false;
    }

    @Override
    public boolean sendForgotPasswordOtp(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String key = email.trim().toLowerCase();
        User user = this.findByEmail(key);
        if (user == null) {
            user = this.get(key);
        }
        if (user != null) {
            String otpCode = EmailUtil.generateOtp();
            user.setCode(otpCode);
            otpStore.put(key, otpCode);
            if (user.getUserName() != null) {
                otpStore.put(user.getUserName().trim().toLowerCase(), otpCode);
            }
            try {
                userDao.update(user);
            } catch (Exception e) {
                System.err.println("[FORGOT PASS] Cập nhật CSDL thất bại, dùng OTP bộ đệm: " + e.getMessage());
            }
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
        String key = email.trim().toLowerCase();
        String inputOtp = otpCode.trim();

        User user = this.findByEmail(key);
        if (user == null) {
            user = this.get(key);
        }

        String expectedOtp = (user != null && user.getCode() != null) ? user.getCode().trim() : otpStore.get(key);

        if (expectedOtp != null && expectedOtp.equalsIgnoreCase(inputOtp)) {
            if (user != null) {
                user.setPassWord(PasswordUtil.hashPassword(newPassword.trim()));
                user.setCode(null); // Xóa mã OTP sau khi đổi mật khẩu
                try {
                    userDao.update(user);
                } catch (Exception ignored) {}
            }
            otpStore.remove(key);
            return true;
        }
        return false;
    }

    @Override
    public boolean checkExistEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        if (pendingUsers.containsKey(email.trim().toLowerCase())) {
            return true;
        }
        return userDao.checkExistEmail(email.trim());
    }

    @Override
    public boolean checkExistUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        if (pendingUsers.containsKey(username.trim().toLowerCase())) {
            return true;
        }
        return userDao.checkExistUsername(username.trim());
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
