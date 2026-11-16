package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.UserServiceImpl;

@WebServlet(urlPatterns = { "/forgot-password" })
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập địa chỉ email đã đăng ký!");
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            return;
        }

        try {
            boolean success = userService.sendForgotPasswordOtp(email.trim());
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + email.trim() + "&msg=sent");
            } else {
                req.setAttribute("alert", "Không tìm thấy tài khoản tương ứng với email này trong hệ thống!");
                req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("[FORGOT PASSWORD ERROR] " + e.getMessage());
            req.setAttribute("alert", "Lỗi xử lý yêu cầu quên mật khẩu: " + e.getMessage());
            req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
        }
    }
}
