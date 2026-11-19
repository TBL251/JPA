package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtil;
import vn.iotstar.util.EmailUtil;

/**
 * Controller Quản lý Hồ sơ Người dùng (User Profile)
 * - Cập nhật Họ và tên, Số điện thoại
 * - Upload ảnh đại diện Avatar lên Cloudinary bằng Multipart
 * - Đổi Email mới: Tự động gửi mã OTP xác nhận tới Email mới
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 25) // 25MB
@WebServlet(urlPatterns = { "/profile", "/profile/update", "/profile/verify-otp", "/profile/resend-otp" })
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("account");
        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            currentUser = userService.get(sessionUser.getUserName());
        }
        if (currentUser == null) {
            currentUser = sessionUser;
        }
        session.setAttribute("account", currentUser);
        req.setAttribute("user", currentUser);

        String uri = req.getRequestURI();

        if (uri.contains("/profile/verify-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            if (pendingEmail == null || pendingEmail.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }
            req.setAttribute("pendingEmail", pendingEmail);
            String msg = req.getParameter("msg");
            if ("sent".equals(msg)) {
                req.setAttribute("message", "Mã xác thực OTP đã được gửi đến email mới: " + pendingEmail + ". Vui lòng kiểm tra hộp thư!");
            } else if ("resent".equals(msg)) {
                req.setAttribute("message", "Đã gửi lại mã OTP mới đến email: " + pendingEmail);
            }
            req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            return;
        }

        if (uri.contains("/profile/resend-otp")) {
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            if (pendingEmail != null && !pendingEmail.trim().isEmpty()) {
                String newOtp = EmailUtil.generateOtp();
                session.setAttribute("profileOtp", newOtp);
                EmailUtil.sendOtpEmail(pendingEmail.trim(), newOtp,
                        "[HCMUTE] Mã xác nhận OTP mới cho yêu cầu đổi Email", "XÁC THỰC EMAIL MỚI");
                resp.sendRedirect(req.getContextPath() + "/profile/verify-otp?msg=resent");
            } else {
                resp.sendRedirect(req.getContextPath() + "/profile");
            }
            return;
        }

        // Thông báo thành công từ redirect
        String msg = req.getParameter("msg");
        if ("success".equals(msg)) {
            req.setAttribute("message", "Cập nhật hồ sơ người dùng thành công!");
        } else if ("email_verified_success".equals(msg)) {
            req.setAttribute("message", "Xác thực OTP thành công! Địa chỉ email mới và thông tin hồ sơ đã được cập nhật.");
        }

        req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("account");
        User currentUser = userService.findById(sessionUser.getId());
        if (currentUser == null) {
            currentUser = userService.get(sessionUser.getUserName());
        }
        if (currentUser == null) {
            currentUser = sessionUser;
        }

        String uri = req.getRequestURI();

        // 1. Xử lý Cập nhật thông tin Profile
        if (uri.contains("/profile/update")) {
            String fullname = req.getParameter("fullname");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");

            // Server-side Validation
            if (fullname == null || fullname.trim().isEmpty() || fullname.trim().length() < 2) {
                req.setAttribute("alert", "Họ và tên không được để trống và phải có ít nhất 2 ký tự!");
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                return;
            }

            if (email == null || email.trim().isEmpty() || !email.trim().matches("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
                req.setAttribute("alert", "Địa chỉ email không đúng định dạng hợp lệ!");
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                return;
            }

            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.trim().matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
                    req.setAttribute("alert", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam gồm 10 chữ số (bắt đầu bằng 03, 05, 07, 08, 09).");
                    req.setAttribute("user", currentUser);
                    req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                    return;
                }
            }

            // Xử lý upload file ảnh avatar lên Cloudinary qua Multipart
            String newAvatarUrl = null;
            try {
                Part avatarPart = req.getPart("avatarFile");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    newAvatarUrl = CloudinaryUtil.uploadFile(avatarPart);
                }
            } catch (Exception e) {
                System.err.println("[AVATAR UPLOAD ERROR] " + e.getMessage());
            }

            String currentEmail = (currentUser.getEmail() != null) ? currentUser.getEmail().trim() : "";
            String inputEmail = email.trim();

            // KIỂM TRA THAY ĐỔI EMAIL: Nếu email mới khác email hiện tại
            if (!inputEmail.equalsIgnoreCase(currentEmail)) {
                // Kiểm tra email mới đã tồn tại ở tài khoản khác chưa
                User existingUser = userService.findByEmail(inputEmail);
                if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                    req.setAttribute("alert", "Email '" + inputEmail + "' đã được sử dụng bởi một tài khoản khác trong hệ thống!");
                    req.setAttribute("user", currentUser);
                    req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
                    return;
                }

                // Sinh mã OTP 6 chữ số và gửi tới EMAIL MỚI
                String otpCode = EmailUtil.generateOtp();
                EmailUtil.sendOtpEmail(inputEmail, otpCode,
                        "[HCMUTE] Mã xác thực OTP cập nhật Email mới cho tài khoản",
                        "XÁC THỰC EMAIL MỚI");

                // Lưu dữ liệu cập nhật tạm thời vào Session để chờ xác nhận mã OTP
                session.setAttribute("pendingFullname", fullname.trim());
                session.setAttribute("pendingPhone", (phone != null ? phone.trim() : ""));
                session.setAttribute("pendingAvatar", (newAvatarUrl != null ? newAvatarUrl : currentUser.getAvatar()));
                session.setAttribute("pendingEmail", inputEmail);
                session.setAttribute("profileOtp", otpCode);

                // Chuyển hướng tới trang nhập mã OTP xác nhận
                resp.sendRedirect(req.getContextPath() + "/profile/verify-otp?msg=sent");
                return;
            }

            // Nếu EMAIL KHÔNG ĐỔI: Cập nhật trực tiếp vào CSDL
            currentUser.setFullName(fullname.trim());
            currentUser.setPhone(phone != null ? phone.trim() : "");
            if (newAvatarUrl != null) {
                currentUser.setAvatar(newAvatarUrl);
            }

            try {
                userService.update(currentUser);
            } catch (Exception e) {
                System.err.println("[PROFILE UPDATE ERROR] " + e.getMessage());
            }

            session.setAttribute("account", currentUser);
            resp.sendRedirect(req.getContextPath() + "/profile?msg=success");
            return;
        }

        // 2. Xử lý Xác thực mã OTP cập nhật Email mới
        if (uri.contains("/profile/verify-otp")) {
            String inputOtp = req.getParameter("otp");
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            String expectedOtp = (String) session.getAttribute("profileOtp");

            if (pendingEmail == null || expectedOtp == null) {
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            if (inputOtp == null || inputOtp.trim().isEmpty() || !inputOtp.trim().matches("^[0-9]{6}$")) {
                req.setAttribute("alert", "Vui lòng nhập đúng 6 chữ số mã OTP!");
                req.setAttribute("pendingEmail", pendingEmail);
                req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
                return;
            }

            if (expectedOtp.equalsIgnoreCase(inputOtp.trim())) {
                // Xác thực thành công: Cập nhật thông tin và Email mới vào CSDL
                String pendingFullname = (String) session.getAttribute("pendingFullname");
                String pendingPhone = (String) session.getAttribute("pendingPhone");
                String pendingAvatar = (String) session.getAttribute("pendingAvatar");

                if (pendingFullname != null) currentUser.setFullName(pendingFullname);
                if (pendingPhone != null) currentUser.setPhone(pendingPhone);
                if (pendingAvatar != null) currentUser.setAvatar(pendingAvatar);
                currentUser.setEmail(pendingEmail);

                try {
                    userService.update(currentUser);
                } catch (Exception e) {
                    System.err.println("[PROFILE VERIFY UPDATE ERROR] " + e.getMessage());
                }

                // Xóa session pending
                session.removeAttribute("pendingFullname");
                session.removeAttribute("pendingPhone");
                session.removeAttribute("pendingAvatar");
                session.removeAttribute("pendingEmail");
                session.removeAttribute("profileOtp");

                session.setAttribute("account", currentUser);
                resp.sendRedirect(req.getContextPath() + "/profile?msg=email_verified_success");
            } else {
                req.setAttribute("alert", "Mã xác thực OTP không chính xác hoặc đã hết hạn! Vui lòng thử lại.");
                req.setAttribute("pendingEmail", pendingEmail);
                req.getRequestDispatcher("/views/profile-verify-otp.jsp").forward(req, resp);
            }
        }
    }
}
