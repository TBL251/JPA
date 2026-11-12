<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Hệ Thống JPA MVC</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h2 { margin-top: 0; text-align: center; color: #0f172a; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="text"], input[type="password"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        .remember-group { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #475569; margin-bottom: 20px; }
        .btn-submit { width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; }
        .btn-submit:hover { background: #1d4ed8; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .success { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #64748b; }
        .footer-links a { color: #2563eb; text-decoration: none; font-weight: 600; }
        .direct-link { text-align: center; margin-top: 15px; font-size: 13px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Đăng Nhập</h2>
        <c:if test="${not empty alert}">
            <div class="alert">${alert}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>
        <form action="<c:url value="/login"/>" method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập:</label>
                <input type="text" id="username" name="username" placeholder="Nhập tài khoản" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu:</label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
            </div>
            <div class="remember-group">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember" style="margin-bottom:0; font-weight:normal; cursor:pointer;">Ghi nhớ đăng nhập (Remember Me)</label>
            </div>
            <button type="submit" class="btn-submit">Đăng Nhập</button>
        </form>
        <div class="footer-links">
            Chưa có tài khoản? <a href="<c:url value="/register"/>">Đăng ký ngay</a>
        </div>
        <div class="direct-link">
            <a href="<c:url value="/admin/categories"/>" style="color: #64748b;">&rarr; Đi thẳng tới trang Quản lý Category</a>
        </div>
    </div>
</body>
</html>

