package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.EmailUtil;

@WebServlet(urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ tên đăng nhập, mật khẩu và email nhận mã OTP!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userService.checkExistUsername(username.trim())) {
                req.setAttribute("alert", "Tên đăng nhập đã tồn tại! Vui lòng chọn tên khác.");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                return;
            }

            if (userService.checkExistEmail(email.trim())) {
                req.setAttribute("alert", "Email này đã được đăng ký trong hệ thống!");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                return;
            }

            // Sinh mã OTP 6 chữ số
            String otpCode = EmailUtil.generateOtp();

            // Đăng ký tài khoản với trạng thái status = 0 (chờ kích hoạt OTP)
            boolean success = userService.register(username.trim(), password.trim(), email.trim(), fullname, phone, otpCode);

            if (success) {
                // Chuyển hướng sang trang xác nhận mã OTP
                req.getSession().setAttribute("verifyEmail", email.trim());
                resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + email.trim() + "&msg=sent");
            } else {
                req.setAttribute("alert", "Đăng ký thất bại! Vui lòng thử lại sau.");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("[REGISTER ERROR] " + e.getMessage());
            req.setAttribute("alert", "Lỗi xử lý đăng ký hoặc kết nối CSDL: " + e.getMessage());
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
        }
    }
}
