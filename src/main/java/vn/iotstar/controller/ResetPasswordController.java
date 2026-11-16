package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

@WebServlet(urlPatterns = { "/reset-password" })
public class ResetPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        req.setAttribute("email", email);

        String msg = req.getParameter("msg");
        if ("sent".equals(msg)) {
            req.setAttribute("message", "Mã xác thực OTP đã được gửi tới email của bạn (hoặc xem tại console log). Vui lòng nhập mã và mật khẩu mới!");
        }

        req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        req.setAttribute("email", email);

        if (email == null || email.trim().isEmpty() || otp == null || otp.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng điền đầy đủ tất cả các trường!");
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp với mật khẩu mới!");
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = userService.resetPassword(email.trim(), otp.trim(), newPassword.trim());
            if (success) {
                req.setAttribute("message", "Đặt lại mật khẩu thành công! Mật khẩu mới đã được mã hóa bảo mật. Mời bạn đăng nhập.");
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("alert", "Mã OTP không chính xác hoặc email không tồn tại!");
                req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("[RESET PASSWORD ERROR] " + e.getMessage());
            req.setAttribute("alert", "Lỗi xử lý đặt lại mật khẩu: " + e.getMessage());
            req.getRequestDispatcher("/views/reset-password.jsp").forward(req, resp);
        }
    }
}
