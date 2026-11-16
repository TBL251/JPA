<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - Hệ Thống HCMUTE JPA</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px 0; }
        .card { background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 440px; }
        h2 { margin-top: 0; text-align: center; color: #0f172a; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 13px; margin-bottom: 22px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        .hint { font-size: 12px; color: #64748b; margin-top: 4px; }
        .btn-submit { width: 100%; padding: 12px; background: #2563eb; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { background: #1d4ed8; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .info-box { background: #eff6ff; border-left: 4px solid #3b82f6; color: #1e40af; padding: 10px 14px; border-radius: 4px; margin-bottom: 18px; font-size: 13px; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #64748b; }
        .footer-links a { color: #2563eb; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Đăng Ký Tài Khoản</h2>
        <div class="subtitle">Kích hoạt tài khoản bằng mã OTP gửi qua Email</div>

        <c:if test="${not empty alert}">
            <div class="alert">${alert}</div>
        </c:if>

        <div class="info-box">
            <b>Lưu ý:</b> Sau khi đăng ký, hệ thống sẽ gửi mã OTP 6 chữ số qua Email để bạn kích hoạt tài khoản. Mật khẩu được mã hóa băm an toàn bằng BCrypt.
        </div>

        <form action="<c:url value='/register'/>" method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập: <span style="color:#ef4444">*</span></label>
                <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu: <span style="color:#ef4444">*</span></label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
            </div>
            <div class="form-group">
                <label for="email">Địa chỉ Email: <span style="color:#ef4444">*</span></label>
                <input type="email" id="email" name="email" placeholder="example@gmail.com" required>
                <div class="hint">Mã OTP kích hoạt sẽ được gửi tới địa chỉ email này.</div>
            </div>
            <div class="form-group">
                <label for="fullname">Họ và tên:</label>
                <input type="text" id="fullname" name="fullname" placeholder="Nhập họ và tên đầy đủ">
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <input type="tel" id="phone" name="phone" placeholder="0901234567">
            </div>
            <button type="submit" class="btn-submit">Đăng Ký & Nhận Mã OTP</button>
        </form>

        <div class="footer-links">
            Đã có tài khoản? <a href="<c:url value='/login'/>">Đăng nhập ngay</a> |
            <a href="<c:url value='/verify-otp'/>">Nhập mã OTP</a>
        </div>
    </div>
</body>
</html>
