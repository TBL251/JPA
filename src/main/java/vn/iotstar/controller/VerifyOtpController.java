package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

@WebServlet(urlPatterns = { "/verify-otp" })
public class VerifyOtpController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email == null || email.isEmpty()) {
            email = (String) req.getSession().getAttribute("verifyEmail");
        }
        req.setAttribute("email", email);

        String action = req.getParameter("action");
        if ("resend".equalsIgnoreCase(action) && email != null && !email.trim().isEmpty()) {
            boolean sent = userService.sendForgotPasswordOtp(email.trim());
            if (sent) {
                req.setAttribute("message", "Mã xác thực OTP mới đã được gửi tới email của bạn (kiểm tra hộp thư hoặc log console).");
            } else {
                req.setAttribute("alert", "Không tìm thấy tài khoản với email này để gửi lại mã!");
            }
        }

        String msg = req.getParameter("msg");
        if ("sent".equals(msg)) {
            req.setAttribute("message", "Hệ thống đã gửi mã OTP xác nhận tới email của bạn. Vui lòng nhập mã để kích hoạt tài khoản!");
        }

        req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otp = req.getParameter("otp");

        if (email == null || email.trim().isEmpty() || otp == null || otp.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ Email và Mã OTP 6 chữ số!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
            return;
        }

        boolean verified = userService.verifyOtp(email.trim(), otp.trim());
        if (verified) {
            req.getSession().removeAttribute("verifyEmail");
            req.setAttribute("message", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("alert", "Mã xác nhận OTP không đúng hoặc tài khoản đã được kích hoạt trước đó!");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }
}
