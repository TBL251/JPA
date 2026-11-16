<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Videos (CRUD) - HCMUTE JPA 3.0</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 30px; background-color: #f8fafc; color: #1e293b; }
        .nav-links { margin-bottom: 20px; display: flex; gap: 15px; align-items: center; }
        .nav-links a { color: #475569; text-decoration: none; font-weight: 500; }
        .nav-links a:hover { color: #2563eb; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; flex-wrap: wrap; gap: 15px; }
        h1 { margin: 0; color: #0f172a; font-size: 24px; }
        .btn { display: inline-block; padding: 9px 18px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 14px; cursor: pointer; transition: all 0.2s; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #dcfce7; color: #166534; }
        .badge-danger { background: #fee2e2; color: #991b1b; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        th, td { padding: 14px 18px; text-align: left; border-bottom: 1px solid #f1f5f9; }
        th { background: #f8fafc; font-weight: 600; color: #475569; text-transform: uppercase; font-size: 12px; letter-spacing: 0.05em; }
        tr:hover { background: #f8fafc; }
        img.thumb { width: 110px; height: 65px; object-fit: cover; border-radius: 6px; border: 1px solid #e2e8f0; }
        .action-link { margin-right: 12px; font-weight: 600; text-decoration: none; font-size: 13px; }
        .action-edit { color: #2563eb; }
        .action-delete { color: #dc2626; }
        .action-view { color: #059669; }
    </style>
</head>
<body>
    <div class="nav-links">
        <a href="<c:url value="/home"/>">&larr; Trang chủ</a> | 
        <a href="<c:url value="/video"/>">Xem trang Video</a> | 
        <a href="<c:url value="/admin/videos"/>"><b>Quản lý Videos (CRUD)</b></a> | 
        <a href="<c:url value="/admin/categories"/>">Quản trị Category</a> | 
        <a href="<c:url value="/logout"/>" style="color: #dc2626;">Đăng xuất</a>
    </div>

    <div class="header">
        <h1>Quản Lý Danh Sách Videos (JPA 3.0 & Hibernate)</h1>
        <a href="<c:url value="/admin/video/add"/>" class="btn btn-primary">+ Thêm Video Mới (Multipart)</a>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 80px;">Mã Video</th>
                <th style="width: 130px;">Poster</th>
                <th>Tiêu đề & Mô tả</th>
                <th style="width: 150px;">Danh mục</th>
                <th style="width: 140px;">Người đăng</th>
                <th style="width: 100px;">Lượt xem</th>
                <th style="width: 110px;">Trạng thái</th>
                <th style="width: 180px;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty listvideo}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #64748b;">
                            Chưa có video nào. Bấm vào <b>"+ Thêm Video Mới"</b> để tạo mới!
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${listvideo}" var="v">
                        <tr>
                            <td><b>${v.videoId}</b></td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.poster != null && v.poster.startsWith('http')}">
                                        <c:url value="${v.poster}" var="pUrl"/>
                                    </c:when>
                                    <c:when test="${v.poster != null && !empty v.poster}">
                                        <c:url value="/image?fname=${v.poster}" var="pUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="https://placehold.co/110x65?text=Video" var="pUrl"/>
                                    </c:otherwise>
                                </c:choose>
                                <img src="${pUrl}" alt="${v.title}" class="thumb" onerror="this.src='https://placehold.co/110x65?text=Video';"/>
                            </td>
                            <td>
                                <div style="font-weight: 600; color: #0f172a; margin-bottom: 4px;">
                                    <a href="<c:url value="/video/detail?id=${v.videoId}"/>" target="_blank" style="color: inherit; text-decoration: none;">
                                        ${v.title}
                                    </a>
                                </div>
                                <div style="font-size: 12px; color: #64748b; max-width: 350px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${v.description}
                                </div>
                            </td>
                            <td>${v.category != null ? v.category.categoryname : 'Chưa phân loại'}</td>
                            <td>${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Quản trị viên'}</td>
                            <td><b>${v.views}</b></td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.active}">
                                        <span class="badge badge-success">&#10003; Hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">&#9679; Ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="<c:url value="/video/detail?id=${v.videoId}"/>" class="action-link action-view" target="_blank">&#9658; Xem</a>
                                <a href="<c:url value="/admin/video/edit?id=${v.videoId}"/>" class="action-link action-edit">&#9998; Sửa</a>
                                <a href="<c:url value="/admin/video/delete?id=${v.videoId}"/>" class="action-link action-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');">&#128465; Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</body>
</html>
