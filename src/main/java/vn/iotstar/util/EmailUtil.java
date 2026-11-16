package vn.iotstar.util;

import java.io.InputStream;
import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * Tiện ích gửi Email qua SMTP (Gmail) hỗ trợ Jakarta Mail 2.1
 * Tự động đọc cấu hình tài khoản gửi từ mail.properties
 */
public class EmailUtil {

    private static String smtpHost = "smtp.gmail.com";
    private static String smtpPort = "587";
    private static String senderEmail = "your_email@gmail.com";
    private static String senderPassword = "your_app_password";

    static {
        loadConfig();
    }

    private static void loadConfig() {
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                smtpHost = props.getProperty("mail.smtp.host", smtpHost);
                smtpPort = props.getProperty("mail.smtp.port", smtpPort);
                senderEmail = props.getProperty("mail.sender.email", senderEmail).trim();
                senderPassword = props.getProperty("mail.sender.password", senderPassword).replace(" ", "").trim();
            }
        } catch (Exception e) {
            System.err.println("[EMAIL CONFIG] Không đọc được mail.properties: " + e.getMessage());
        }
    }

    /**
     * Cập nhật thông tin tài khoản SMTP gửi mail
     */
    public static void setSenderCredentials(String email, String appPassword) {
        if (email != null && !email.trim().isEmpty()) {
            senderEmail = email.trim();
        }
        if (appPassword != null && !appPassword.trim().isEmpty()) {
            senderPassword = appPassword.replace(" ", "").trim();
        }
    }

    public static String getSenderEmail() {
        return senderEmail;
    }

    public static String getSenderPassword() {
        return senderPassword;
    }

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    /**
     * Gửi mã OTP xác nhận tài khoản / quên mật khẩu tới email người dùng
     *
     * @param toEmail Email người nhận
     * @param otpCode Mã OTP 6 chữ số
     * @param subject Tiêu đề thư
     * @param messageType Loại thông báo (KÍCH HOẠT TÀI KHOẢN, QUÊN MẬT KHẨU...)
     * @return true nếu gửi thành công hoặc đã ghi log mã OTP
     */
    public static boolean sendOtpEmail(String toEmail, String otpCode, String subject, String messageType) {
        // Tải lại cấu hình mới nhất nếu có cập nhật file
        loadConfig();

        // Luôn log mã OTP ra console để hỗ trợ kiểm thử song song
        System.out.println("=====================================================================");
        System.out.println("[EMAIL SERVICE] Loại thông báo: " + messageType);
        System.out.println("[EMAIL SERVICE] Email người gửi: " + senderEmail);
        System.out.println("[EMAIL SERVICE] Email người nhận: " + toEmail);
        System.out.println("[EMAIL SERVICE] MÃ XÁC NHẬN OTP: >>> " + otpCode + " <<<");
        System.out.println("=====================================================================");

        if (toEmail == null || toEmail.trim().isEmpty()) {
            return false;
        }

        // Kiểm tra xem đã cấu hình mật khẩu ứng dụng thật hay chưa
        boolean hasRealCredentials = senderEmail != null && senderEmail.contains("@")
                && !senderEmail.startsWith("dien_")
                && senderPassword != null && !senderPassword.isEmpty()
                && !senderPassword.startsWith("dien_")
                && !"your_app_password".equals(senderPassword);

        if (!hasRealCredentials) {
            System.out.println("[EMAIL SERVICE CHÚ Ý] Chưa cấu hình email và Mật khẩu ứng dụng trong file mail.properties.");
            System.out.println("[EMAIL SERVICE CHÚ Ý] Hãy điền email và App Password vào mail.properties để gửi email thật qua mạng.");
            return true;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.connectiontimeout", "8000");
        props.put("mail.smtp.timeout", "8000");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        };

        boolean success = false;
        try {
            Session session = Session.getInstance(props, auth);

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, "HCMUTE Web System", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");

            String htmlContent = "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e2e8f0; border-radius: 8px; background: #ffffff;\">"
                    + "<h2 style=\"color: #2563eb; text-align: center; margin-top: 0;\">HCMUTE - XÁC THỰC TÀI KHOẢN</h2>"
                    + "<p style=\"color: #334155; font-size: 15px;\">Xin chào quý người dùng,</p>"
                    + "<p style=\"color: #334155; font-size: 15px;\">Hệ thống nhận được yêu cầu <b>" + messageType + "</b> cho tài khoản liên kết với địa chỉ email này.</p>"
                    + "<p style=\"color: #334155; font-size: 15px;\">Mã xác thực OTP của bạn là:</p>"
                    + "<div style=\"text-align: center; margin: 28px 0;\">"
                    + "<span style=\"display: inline-block; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #0f172a; background: #f1f5f9; padding: 14px 28px; border-radius: 8px; border: 2px dashed #94a3b8;\">"
                    + otpCode + "</span>"
                    + "</div>"
                    + "<p style=\"color: #64748b; font-size: 13px;\">Mã OTP có hiệu lực trong vòng 10 phút. Tuyệt đối không chia sẻ mã này cho người khác để đảm bảo an toàn tài khoản.</p>"
                    + "<hr style=\"border: none; border-top: 1px solid #e2e8f0; margin: 24px 0;\"/>"
                    + "<p style=\"color: #94a3b8; font-size: 12px; text-align: center; margin-bottom: 0;\">Đây là email tự động từ hệ thống Lập trình Web HCMUTE, vui lòng không trả lời thư này.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EMAIL SERVICE THÀNH CÔNG] >>> Đã gửi email thật qua mạng Internet tới: " + toEmail + " <<<");
            success = true;
        } catch (Exception e) {
            System.err.println("[EMAIL SERVICE LỖI GỬI THẬT] " + e.getMessage());
            e.printStackTrace();
            success = false;
        } finally {
            // Đóng xử lý gửi thư
        }
        return success;
    }
}
