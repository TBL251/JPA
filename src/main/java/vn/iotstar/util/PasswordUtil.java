package vn.iotstar.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Tiện ích băm và kiểm tra mật khẩu sử dụng BCrypt
 * Hỗ trợ tương thích ngược cho mật khẩu plaintext cũ
 */
public class PasswordUtil {

    /**
     * Băm mật khẩu người dùng với muối (salt) sinh tự động
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /**
     * Kiểm tra mật khẩu nhập vào có khớp với mật khẩu đã băm hay không
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        // Kiểm tra định dạng hash BCrypt chuẩn ($2a$, $2b$, $2y$)
        if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")) {
            try {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            } catch (Exception e) {
                System.err.println("[BCRYPT ERROR] " + e.getMessage());
                return false;
            }
        }
        // Tương thích với mật khẩu chưa mã hóa (plaintext như '123' trong database mẫu)
        return plainPassword.equals(hashedPassword);
    }
}
