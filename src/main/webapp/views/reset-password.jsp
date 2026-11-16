<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu - HCMUTE JPA</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px 0; }
        .card { background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 440px; }
        h2 { margin-top: 0; text-align: center; color: #0f172a; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 14px; margin-bottom: 22px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="text"], input[type="password"], input[type="email"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input.otp-input { font-size: 20px; font-weight: bold; letter-spacing: 6px; text-align: center; color: #0f172a; background: #f8fafc; }
        .btn-submit { width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { background: #1d4ed8; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .success { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #64748b; }
        .footer-links a { color: #2563eb; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Đặt Lại Mật Khẩu</h2>
        <div class="subtitle">Nhập mã OTP đã nhận và thiết lập mật khẩu mới</div>

        <c:if test="${not empty alert}">
            <div class="alert">${alert}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>

        <form action="<c:url value="/reset-password"/>" method="post">
            <div class="form-group">
                <label for="email">Địa chỉ Email:</label>
                <input type="email" id="email" name="email" value="${email}" placeholder="example@gmail.com" required>
            </div>
            <div class="form-group">
                <label for="otp">Mã xác thực OTP (6 chữ số):</label>
                <input type="text" id="otp" name="otp" class="otp-input" maxlength="6" placeholder="------" required autofocus>
            </div>
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới:</label>
                <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
            </div>
            <button type="submit" class="btn-submit">&#10003; Cập Nhật Mật Khẩu Mới</button>
        </form>

        <div class="footer-links">
            Nhớ lại mật khẩu? <a href="<c:url value="/login"/>">Đăng nhập</a> |
            <a href="<c:url value="/forgot-password"/>">Gửi lại mã OTP</a>
        </div>
    </div>
</body>
</html>
