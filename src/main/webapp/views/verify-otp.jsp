<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kích Hoạt Tài Khoản Bằng OTP - HCMUTE</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 420px; }
        h2 { margin-top: 0; text-align: center; color: #0f172a; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 14px; margin-bottom: 22px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="text"], input[type="email"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input.otp-input { font-size: 24px; font-weight: bold; letter-spacing: 8px; text-align: center; color: #0f172a; background: #f8fafc; }
        .btn-submit { width: 100%; padding: 12px; background: #059669; color: #fff; border: none; border-radius: 6px; font-weight: 600; font-size: 15px; cursor: pointer; }
        .btn-submit:hover { background: #047857; }
        .alert { background: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .success { background: #dcfce7; border-left: 4px solid #22c55e; color: #166534; padding: 10px 14px; border-radius: 4px; margin-bottom: 16px; font-size: 14px; }
        .resend-box { text-align: center; margin-top: 20px; font-size: 13px; color: #64748b; }
        .resend-box a { color: #2563eb; text-decoration: none; font-weight: 600; }
        .resend-box a:hover { text-decoration: underline; }
        .dev-tip { margin-top: 20px; padding: 12px; background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 6px; font-size: 12px; color: #475569; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Xác Thực Mã OTP</h2>
        <div class="subtitle">Nhập mã xác thực 6 chữ số được gửi tới Email của bạn</div>

        <c:if test="${not empty alert}">
            <div class="alert">${alert}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>

        <form action="<c:url value="/verify-otp"/>" method="post">
            <div class="form-group">
                <label for="email">Địa chỉ Email đăng ký:</label>
                <input type="email" id="email" name="email" value="${email}" placeholder="example@gmail.com" required>
            </div>
            <div class="form-group">
                <label for="otp">Mã xác nhận OTP (6 chữ số):</label>
                <input type="text" id="otp" name="otp" class="otp-input" maxlength="6" placeholder="------" required autofocus>
            </div>
            <button type="submit" class="btn-submit">&#10003; Xác Nhận & Kích Hoạt Tài Khoản</button>
        </form>

        <div class="resend-box">
            Chưa nhận được mã? 
            <a href="<c:url value="/verify-otp?action=resend&email=${email}"/>">Gửi lại mã OTP</a>
        </div>

        <div class="resend-box" style="margin-top: 10px;">
            <a href="<c:url value="/login"/>">&larr; Quay lại Đăng Nhập</a>
        </div>

        <div class="dev-tip">
            <b>Mẹo kiểm thử (Dev Mode):</b> Nếu máy chủ chưa kết nối được máy chủ SMTP Google bên ngoài, bạn có thể xem trực tiếp mã OTP 6 số được ghi nhận tức thì trong <b>cửa sổ dòng lệnh (Console Log)</b> của máy chủ Tomcat.
        </div>
    </div>
</body>
</html>
