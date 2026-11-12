<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Danh Mục - JPA 3.0</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 40px auto; max-width: 650px; background-color: #f8fafc; color: #1e293b; }
        .card { background: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        h2 { margin-top: 0; color: #0f172a; font-size: 22px; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; font-size: 14px; color: #334155; }
        input[type="text"], input[type="file"] { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input[type="text"]:focus { outline: none; border-color: #2563eb; }
        .radio-group { display: flex; gap: 20px; align-items: center; margin-top: 6px; }
        .radio-group label { display: inline-flex; align-items: center; gap: 6px; font-weight: normal; cursor: pointer; }
        .actions { display: flex; gap: 12px; margin-top: 25px; }
        .btn { padding: 10px 22px; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; border: none; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-secondary { background: #e2e8f0; color: #334155; }
        .btn-secondary:hover { background: #cbd5e1; }
        .img-preview { margin: 10px 0; }
        .img-preview img { width: 140px; height: 100px; object-fit: cover; border-radius: 6px; border: 1px solid #cbd5e1; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Cập Nhật Danh Mục #${cate.categoryid}</h2>
        <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="categoryid" value="${cate.categoryid}">
            
            <div class="form-group">
                <label for="categoryname">Tên Danh Mục (Category Name):</label>
                <input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}" required>
            </div>

            <div class="form-group">
                <label for="images">Link hình ảnh (URL nếu có):</label>
                <input type="text" id="images" name="images" value="${cate.images}">
            </div>

            <div class="form-group">
                <label>Ảnh hiện tại:</label>
                <div class="img-preview">
                    <c:choose>
                        <c:when test="${cate.images != null && cate.images.startsWith('https')}">
                            <c:url value="${cate.images}" var="imgUrl"/>
                        </c:when>
                        <c:when test="${cate.images != null && !empty cate.images}">
                            <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                        </c:when>
                        <c:otherwise>
                            <c:url value="https://placehold.co/140x100?text=No+Image" var="imgUrl"/>
                        </c:otherwise>
                    </c:choose>
                    <img src="${imgUrl}" alt="${cate.categoryname}" 
                         onerror="this.onerror=null; this.src='https://placehold.co/140x100?text=Image';"/>
                </div>
            </div>

            <div class="form-group">
                <label for="images1">Thay đổi ảnh (Tải file mới từ máy tính):</label>
                <input type="file" id="images1" name="images1" accept="image/*">
            </div>

            <div class="form-group">
                <label>Trạng thái (Status):</label>
                <div class="radio-group">
                    <label>
                        <input type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}> Hoạt động
                    </label>
                    <label>
                        <input type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}> Khóa
                    </label>
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-primary">Cập Nhật</button>
                <a href="<c:url value="/admin/categories"/>" class="btn btn-secondary">Quay lại danh sách</a>
            </div>
        </form>
    </div>
</body>
</html>

