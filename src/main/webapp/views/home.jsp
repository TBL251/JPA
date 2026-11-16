<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - HCMUTE Video & Shopping (JPA 3.0)</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background-color: #f8fafc; color: #1e293b; }
        .navbar { background: #0f172a; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .navbar-brand { font-weight: 700; font-size: 18px; color: #38bdf8; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .navbar-menu { display: flex; align-items: center; gap: 18px; flex-wrap: wrap; }
        .navbar-menu a { color: #cbd5e1; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
        .navbar-menu a:hover, .navbar-menu a.active { color: #38bdf8; }
        .hero { text-align: center; padding: 45px 20px; background: linear-gradient(135deg, #1e293b, #0f172a); color: #fff; }
        .hero h1 { font-size: 32px; margin-bottom: 12px; }
        .hero p { color: #94a3b8; font-size: 16px; margin-bottom: 24px; }
        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-left: 4px solid #2563eb; padding-left: 12px; }
        .section-title { font-size: 22px; font-weight: 700; color: #0f172a; margin: 0; }
        .view-all-link { color: #2563eb; font-weight: 600; font-size: 14px; text-decoration: none; }
        .view-all-link:hover { text-decoration: underline; }
        .video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; margin-bottom: 50px; }
        .video-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
        .poster-container { position: relative; width: 100%; height: 160px; background: #000; overflow: hidden; }
        .poster-container img { width: 100%; height: 100%; object-fit: cover; opacity: 0.9; transition: opacity 0.2s; }
        .video-card:hover .poster-container img { opacity: 1; }
        .play-overlay { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 44px; height: 44px; background: rgba(37,99,235,0.85); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 18px; opacity: 0; transition: opacity 0.2s; }
        .video-card:hover .play-overlay { opacity: 1; }
        .video-body { padding: 16px; flex-grow: 1; display: flex; flex-direction: column; }
        .video-title { font-size: 15px; font-weight: 600; margin-bottom: 8px; line-height: 1.4; }
        .video-title a { color: #0f172a; text-decoration: none; }
        .video-title a:hover { color: #2563eb; text-decoration: underline; }
        .video-meta { margin-top: auto; display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: #64748b; padding-top: 10px; border-top: 1px solid #f1f5f9; }
        .badge { display: inline-block; padding: 2px 7px; border-radius: 4px; font-size: 11px; font-weight: 600; }
        .badge-views { background: #eff6ff; color: #1e40af; }
        .badge-user { background: #f1f5f9; color: #475569; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }
        .card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .card img { width: 100%; height: 170px; object-fit: cover; }
        .card-body { padding: 16px; }
        .card-title { font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #0f172a; }
        .badge-success { background: #dcfce7; color: #166534; }
        .badge-danger { background: #fee2e2; color: #991b1b; }
        .btn { display: inline-block; padding: 8px 16px; background: #2563eb; color: #fff; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="<c:url value="/home"/>" class="navbar-brand">
            &#9654; HCMUTE VIDEO & SHOPPING
        </a>
        <div class="navbar-menu">
            <a href="<c:url value="/home"/>" class="active">Trang Chủ</a>
            <a href="<c:url value="/video"/>">Video Của Tôi (/video)</a>
            <c:if test="${not empty sessionScope.account && (sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2)}">
                <a href="<c:url value="/admin/videos"/>" style="color: #f59e0b; font-weight: 600;">[Quản Lý Videos]</a>
                <a href="<c:url value="/admin/categories"/>" style="color: #38bdf8; font-weight: 600;">[Quản Trị Category]</a>
            </c:if>
            <c:choose>
                <c:when test="${not empty sessionScope.account}">
                    <span style="color: #cbd5e1; font-size: 13px;">Xin chào, <b>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</b></span>
                    <a href="<c:url value="/logout"/>" style="color: #f87171;">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value="/login"/>">Đăng nhập</a>
                    <a href="<c:url value="/register"/>">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="hero">
        <h1>Nền Tảng Đa Phương Tiện & Mua Sắm JPA 3.0</h1>
        <p>Phát triển bởi Khoa CNTT - Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)</p>
        <div style="display: flex; justify-content: center; gap: 15px;">
            <a href="<c:url value="/video"/>" class="btn" style="padding: 10px 20px; background: #059669;">Xem Tất Cả Video Của Bạn (/video) &rarr;</a>
            <c:if test="${empty sessionScope.account}">
                <a href="<c:url value="/register"/>" class="btn" style="padding: 10px 20px; background: #2563eb;">Đăng Ký Tài Khoản OTP &rarr;</a>
            </c:if>
        </div>
    </div>

    <div class="container">
        <!-- 1. Hiển thị 10 video mới nhất lên trang chủ theo yêu cầu -->
        <div class="section-header">
            <h2 class="section-title">10 Video Mới Nhất</h2>
            <a href="<c:url value="/video"/>" class="view-all-link">Xem tất cả video &rarr;</a>
        </div>

        <div class="video-grid">
            <c:choose>
                <c:when test="${empty topVideos}">
                    <p style="grid-column: 1/-1; text-align: center; color: #64748b; padding: 40px;">
                        Chưa có video nào trong hệ thống.
                    </p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${topVideos}" var="v">
                        <div class="video-card">
                            <div class="poster-container">
                                <c:choose>
                                    <c:when test="${v.poster != null && v.poster.startsWith('http')}">
                                        <c:url value="${v.poster}" var="posterUrl"/>
                                    </c:when>
                                    <c:when test="${v.poster != null && !empty v.poster}">
                                        <c:url value="/image?fname=${v.poster}" var="posterUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="https://placehold.co/300x180?text=Video" var="posterUrl"/>
                                    </c:otherwise>
                                </c:choose>
                                <a href="<c:url value="/video/detail?id=${v.videoId}"/>">
                                    <img src="${posterUrl}" alt="${v.title}" onerror="this.src='https://placehold.co/300x180?text=Video';"/>
                                    <div class="play-overlay">&#9658;</div>
                                </a>
                            </div>
                            <div class="video-body">
                                <div class="video-title">
                                    <!-- Bấm chuột vào tiêu đề chuyển sang chi tiết và play video -->
                                    <a href="<c:url value="/video/detail?id=${v.videoId}"/>" title="${v.title}">
                                        ${v.title}
                                    </a>
                                </div>
                                <div class="video-meta">
                                    <span class="badge badge-views">&#128065; ${v.views} lượt xem</span>
                                    <span class="badge badge-user">&#128100; ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Quản trị viên'}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 2. Danh sách Danh mục sản phẩm (Categories) -->
        <div class="section-header">
            <h2 class="section-title">Danh Sách Danh Mục Sản Phẩm</h2>
        </div>

        <div class="grid">
            <c:choose>
                <c:when test="${empty listcate}">
                    <p style="grid-column: 1/-1; text-align: center; color: #64748b; padding: 40px;">
                        Chưa có danh mục nào.
                    </p>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${listcate}" var="c">
                        <div class="card">
                            <c:choose>
                                <c:when test="${c.images != null && c.images.startsWith('http')}">
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
                                <c:choose>
                                    <c:when test="${c.status == 1}">
                                        <span class="badge badge-success">&#10003; Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">&#9679; Tạm khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
