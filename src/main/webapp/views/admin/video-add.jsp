<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Video Mới (Multipart) - HCMUTE JPA 3.0</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background-color: #f8fafc; color: #1e293b; }
        .container { max-width: 650px; margin: 0 auto; background: #fff; padding: 35px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        h1 { margin-top: 0; color: #0f172a; font-size: 22px; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px; color: #334155; }
        input[type="text"], textarea, select { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input[type="file"] { padding: 8px 0; font-size: 13px; }
        .hint { font-size: 12px; color: #64748b; margin-top: 4px; }
        .btn-group { display: flex; gap: 12px; margin-top: 30px; }
        .btn { padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px; cursor: pointer; text-decoration: none; border: none; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-secondary { background: #e2e8f0; color: #475569; }
        .btn-secondary:hover { background: #cbd5e1; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Thêm Video Mới (Hỗ trợ Upload Multipart)</h1>
        <form action="<c:url value="/admin/video/insert"/>" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="videoId">Mã Video (ID): <span style="color:#ef4444">*</span></label>
                <input type="text" id="videoId" name="videoId" placeholder="Ví dụ: v13, vid_01..." required>
            </div>

            <div class="form-group">
                <label for="title">Tiêu đề Video: <span style="color:#ef4444">*</span></label>
                <input type="text" id="title" name="title" placeholder="Nhập tiêu đề video" required>
            </div>

            <div class="form-group">
                <label for="categoryId">Danh mục (Category):</label>
                <select id="categoryId" name="categoryId">
                    <option value="">-- Chọn danh mục liên kết --</option>
                    <c:forEach items="${listcate}" var="c">
                        <option value="${c.categoryId}">${c.categoryname}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="posterFile">Tải lên file ảnh Poster (Multipart):</label>
                <input type="file" id="posterFile" name="posterFile" accept="image/*">
                <div class="hint">Hỗ trợ file định dạng .jpg, .png, .webp (Tự động lưu vào thư mục hệ thống E:/upload hoặc C:/upload).</div>
            </div>

            <div class="form-group">
                <label for="poster">Hoặc nhập liên kết Poster (URL Trực Tuyến):</label>
                <input type="text" id="poster" name="poster" placeholder="https://images.unsplash.com/...">
            </div>

            <div class="form-group">
                <label for="description">Mô tả video:</label>
                <textarea id="description" name="description" rows="4" placeholder="Nhập thông tin giới thiệu nội dung video..."></textarea>
            </div>

            <div class="form-group">
                <label>Trạng thái hiển thị:</label>
                <label style="font-weight: normal; display: flex; align-items: center; gap: 8px; cursor: pointer;">
                    <input type="checkbox" name="active" value="1" checked> Hiển thị video công khai
                </label>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">&#10003; Lưu Video</button>
                <a href="<c:url value="/admin/videos"/>" class="btn btn-secondary">Hủy bỏ</a>
            </div>
        </form>
    </div>
</body>
</html>
