<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Danh Mục (Category) - JPA 3.0</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background-color: #f8fafc; color: #1e293b; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; }
        h1 { margin: 0; color: #0f172a; font-size: 24px; }
        .btn { display: inline-block; padding: 9px 18px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; cursor: pointer; transition: all 0.2s; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-danger { color: #dc2626; }
        .btn-edit { color: #2563eb; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #dcfce7; color: #166534; }
        .badge-danger { background: #fee2e2; color: #991b1b; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        th, td { padding: 14px 18px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        th { background: #f8fafc; font-weight: 600; color: #475569; text-transform: uppercase; font-size: 12px; letter-spacing: 0.05em; }
        tr:hover { background: #f8fafc; }
        img.thumb { width: 120px; height: 90px; object-fit: cover; border-radius: 6px; border: 1px solid #e2e8f0; }
        .nav-links { margin-bottom: 15px; }
        .nav-links a { margin-right: 15px; color: #475569; text-decoration: none; font-weight: 500; }
        .nav-links a:hover { color: #2563eb; }
    </style>
</head>
<body>
    <div class="nav-links">
        <a href="<c:url value="/home"/>">Trang chủ</a> | 
        <a href="<c:url value="/admin/categories"/>"><b>Quản lý Danh mục (JPA)</b></a> | 
        <a href="<c:url value="/logout"/>">Đăng xuất</a>
    </div>

    <div class="header">
        <h1>Quản lý Danh mục bằng Công nghệ JPA 3.0 & Hibernate</h1>
        <a href="<c:url value="/admin/category/add"/>" class="btn btn-primary">+ Thêm Danh mục mới</a>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 60px;">STT</th>
                <th style="width: 150px;">Hình ảnh</th>
                <th>Tên Danh mục</th>
                <th style="width: 140px;">Trạng thái</th>
                <th style="width: 150px;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty listcate}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 30px; color: #64748b;">
                            Chưa có danh mục nào trong CSDL. Bấm vào <b>"+ Thêm Danh mục mới"</b> để tạo!
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${listcate}" var="cate" varStatus="STT">
                        <tr>
                            <td><b>${STT.index + 1}</b></td>
                            <td>
                                <c:choose>
                                    <c:when test="${cate.images != null && cate.images.startsWith('https')}">
                                        <c:url value="${cate.images}" var="imgUrl"/>
                                    </c:when>
                                    <c:when test="${cate.images != null && !empty cate.images}">
                                        <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="https://placehold.co/120x90?text=No+Image" var="imgUrl"/>
                                    </c:otherwise>
                                </c:choose>
                                <img class="thumb" src="${imgUrl}" alt="${cate.categoryname}" 
                                     onerror="this.onerror=null; this.src='https://placehold.co/120x90?text=Category';"/>
                            </td>
                            <td>
                                <strong style="font-size: 15px; color: #0f172a;">${cate.categoryname}</strong>
                                <div style="font-size: 12px; color: #94a3b8; margin-top: 4px;">ID: ${cate.categoryid}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${cate.status == 1}">
                                        <span class="badge badge-success">&#9679; Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">&#9679; Khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn btn-edit">Sửa</a>
                                &nbsp;|&nbsp;
                                <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" class="btn btn-danger"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</body>
</html>

