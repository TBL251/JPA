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
        String confirmPassword = req.getParameter("confirmPassword");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        // Giữ lại giá trị người dùng đã nhập
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);

        // Validation kiểm tra rỗng
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()
                || email == null || email.trim().isEmpty() || fullname == null || fullname.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng điền đầy đủ các trường thông tin bắt buộc (*): Tên đăng nhập, Mật khẩu, Email, Họ và tên!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validation độ dài và định dạng Username (3-30 ký tự, chữ cái, số, gạch dưới)
        if (!username.trim().matches("^[a-zA-Z0-9_]{3,30}$")) {
            req.setAttribute("alert", "Tên đăng nhập không hợp lệ! Chỉ cho phép 3 - 30 ký tự gồm chữ cái, số và dấu gạch dưới (_).");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validation độ dài mật khẩu (tối thiểu 6 ký tự)
        if (password.trim().length() < 6) {
            req.setAttribute("alert", "Mật khẩu quá ngắn! Mật khẩu phải có độ dài từ 6 ký tự trở lên.");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validation xác nhận mật khẩu khớp
        if (confirmPassword != null && !password.trim().equals(confirmPassword.trim())) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp với mật khẩu đã nhập!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validation định dạng Email
        if (!email.trim().matches("^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("alert", "Địa chỉ email không đúng định dạng (ví dụ hợp lệ: ten@gmail.com)!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        // Validation định dạng Số điện thoại (nếu có nhập)
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
                req.setAttribute("alert", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam gồm 10 chữ số (bắt đầu bằng 03, 05, 07, 08, 09).");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                return;
            }
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
