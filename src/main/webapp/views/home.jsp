<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - HCMUTE Shopping</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background-color: #f8fafc; color: #1e293b; }
        .navbar { background: #0f172a; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: #cbd5e1; text-decoration: none; margin-left: 20px; font-weight: 500; }
        .navbar a:hover { color: #fff; }
        .hero { text-align: center; padding: 50px 20px; background: linear-gradient(135deg, #1e293b, #0f172a); color: #fff; }
        .hero h1 { font-size: 32px; margin-bottom: 12px; }
        .hero p { color: #94a3b8; font-size: 16px; margin-bottom: 24px; }
        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        .section-title { font-size: 22px; font-weight: 700; margin-bottom: 25px; border-left: 4px solid #2563eb; padding-left: 12px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }
        .card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .card:hover { transform: translateY(-4px); }
        .card img { width: 100%; height: 180px; object-fit: cover; }
        .card-body { padding: 16px; }
        .card-title { font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #0f172a; }
        .badge { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #dcfce7; color: #166534; }
        .btn { display: inline-block; padding: 8px 16px; background: #2563eb; color: #fff; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <div style="font-weight: 700; font-size: 18px;">HCMUTE SHOPPING (JPA 3.0)</div>
        <div>
            <a href="<c:url value="/home"/>">Trang chủ</a>
            <a href="<c:url value="/admin/categories"/>">Quản lý Category</a>
            <c:choose>
                <c:when test="${not empty sessionScope.account}">
                    <span style="margin-left: 20px; color: #38bdf8;">Xin chào, <b>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</b></span>
                    <a href="<c:url value="/logout"/>">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value="/login"/>">Đăng nhập</a>
                    <a href="<c:url value="/register"/>">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="hero">
        <h1>Hệ Thống Quản Lý Category với JPA 3.0 & Hibernate</h1>
        <p>Khoa Công nghệ Thông tin - Trường ĐH Sư phạm Kỹ thuật TP.HCM (HCMUTE)</p>
        <a href="<c:url value="/admin/categories"/>" class="btn" style="padding: 12px 24px; font-size: 15px;">Truy cập trang Quản trị Category &rarr;</a>
    </div>

    <div class="container">
        <div class="section-title">Danh Sách Danh Mục Đang Hoạt Động</div>
        <div class="grid">
            <c:choose>
                <c:when test="${empty listcate}">
                    <p style="grid-column: 1/-1; text-align: center; color: #64748b; padding: 40px;">
                        Chưa có danh mục nào. Hãy đăng nhập với vai trò Quản trị viên để thêm mới!
                    </p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${listcate}" var="c">
                        <c:if test="${c.status == 1}">
                            <div class="card">
                                <c:choose>
                                    <c:when test="${c.images != null && c.images.startsWith('https')}">
                                        <c:url value="${c.images}" var="imgUrl"/>
                                    </c:when>
                                    <c:when test="${c.images != null && !empty c.images}">
                                        <c:url value="/image?fname=${c.images}" var="imgUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="https://placehold.co/260x180?text=Category" var="imgUrl"/>
                                    </c:otherwise>
                                </c:choose>
                                <img src="${imgUrl}" alt="${c.categoryname}" 
                                     onerror="this.onerror=null; this.src='https://placehold.co/260x180?text=Category';"/>
                                <div class="card-body">
                                    <div class="card-title">${c.categoryname}</div>
                                    <span class="badge badge-success">&#10003; Đang mở bán</span>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>

