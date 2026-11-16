<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu - HCMUTE JPA</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 420px; }
        h2 { margin-top: 0; text-align: center; color: #0f172a; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 14px; margin-bottom: 22px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="email"], input[type="text"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        .btn-submit { width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; }
        .btn-submit:hover { background: #1d4ed8; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #64748b; }
        .footer-links a { color: #2563eb; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Quên Mật Khẩu</h2>
        <div class="subtitle">Nhận mã OTP qua Email để khôi phục mật khẩu tài khoản</div>

        <c:if test="${not empty alert}">
            <div class="alert">${alert}</div>
        </c:if>

        <form action="<c:url value="/forgot-password"/>" method="post">
            <div class="form-group">
                <label for="email">Email đã đăng ký tài khoản:</label>
                <input type="email" id="email" name="email" placeholder="example@gmail.com" required autofocus>
            </div>
            <button type="submit" class="btn-submit">Gửi Mã Xác Nhận OTP &rarr;</button>
        </form>

        <div class="footer-links">
            Nhớ lại mật khẩu? <a href="<c:url value="/login"/>">Quay lại Đăng nhập</a>
        </div>
    </div>
</body>
</html>
