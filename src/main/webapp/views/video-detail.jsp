<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${video.title} - Phát Video HCMUTE</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; background-color: #0f172a; color: #f8fafc; }
        .navbar { background: #1e293b; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #334155; }
        .navbar-brand { font-weight: 700; font-size: 18px; color: #38bdf8; text-decoration: none; }
        .navbar-menu { display: flex; align-items: center; gap: 18px; }
        .navbar-menu a { color: #cbd5e1; text-decoration: none; font-size: 14px; font-weight: 500; }
        .navbar-menu a:hover { color: #38bdf8; }
        .container { max-width: 1300px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 380px; gap: 30px; }
        @media (max-width: 992px) {
            .container { grid-template-columns: 1fr; }
        }
        .player-wrapper { background: #000; border-radius: 12px; overflow: hidden; position: relative; width: 100%; aspect-ratio: 16/9; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        .player-wrapper video { width: 100%; height: 100%; object-fit: contain; }
        .player-wrapper iframe { width: 100%; height: 100%; border: none; }
        .video-details { margin-top: 20px; background: #1e293b; padding: 24px; border-radius: 12px; border: 1px solid #334155; }
        .video-title { font-size: 22px; font-weight: 700; margin: 0 0 14px 0; color: #fff; line-height: 1.4; }
        .meta-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #334155; padding-bottom: 16px; margin-bottom: 18px; flex-wrap: wrap; gap: 10px; font-size: 14px; color: #94a3b8; }
        .uploader-info { display: flex; align-items: center; gap: 12px; }
        .avatar-circle { width: 42px; height: 42px; border-radius: 50%; background: #3b82f6; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; font-size: 16px; }
        .uploader-name { font-weight: 600; color: #f1f5f9; }
        .uploader-role { font-size: 12px; color: #64748b; }
        .video-stats { display: flex; gap: 15px; align-items: center; }
        .stat-badge { background: #0f172a; padding: 6px 14px; border-radius: 20px; border: 1px solid #334155; font-size: 13px; color: #38bdf8; }
        .description-box { font-size: 14px; line-height: 1.6; color: #cbd5e1; white-space: pre-line; }
        .actions-bar { margin-top: 20px; display: flex; gap: 12px; flex-wrap: wrap; }
        .btn-action { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 6px; background: #334155; color: #f8fafc; text-decoration: none; font-size: 13px; font-weight: 600; transition: background 0.2s; }
        .btn-action:hover { background: #475569; }
        .btn-primary { background: #2563eb; }
        .btn-primary:hover { background: #1d4ed8; }
        /* Sidebar styles */
        .sidebar { background: #1e293b; padding: 20px; border-radius: 12px; border: 1px solid #334155; height: fit-content; }
        .sidebar-title { font-size: 17px; font-weight: 700; color: #fff; margin-top: 0; margin-bottom: 18px; border-left: 3px solid #38bdf8; padding-left: 10px; }
        .related-list { display: flex; flex-direction: column; gap: 16px; }
        .related-item { display: flex; gap: 12px; text-decoration: none; color: inherit; transition: opacity 0.2s; }
        .related-item:hover { opacity: 0.85; }
        .related-thumb { width: 120px; height: 75px; border-radius: 6px; overflow: hidden; flex-shrink: 0; background: #000; }
        .related-thumb img { width: 100%; height: 100%; object-fit: cover; }
        .related-info { flex-grow: 1; display: flex; flex-direction: column; justify-content: center; }
        .related-title { font-size: 13px; font-weight: 600; color: #f1f5f9; line-height: 1.3; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .related-meta { font-size: 11px; color: #64748b; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="<c:url value="/home"/>" class="navbar-brand">&#9654; HCMUTE VIDEO & SHOPPING</a>
        <div class="navbar-menu">
            <a href="<c:url value="/home"/>">Trang Chủ</a>
            <a href="<c:url value="/video"/>">Video Của Tôi</a>
            <c:if test="${not empty sessionScope.account && (sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2)}">
                <a href="<c:url value="/admin/videos"/>" style="color: #f59e0b;">[Quản Lý Videos]</a>
                <a href="<c:url value="/admin/categories"/>" style="color: #38bdf8;">[Quản Trị Category]</a>
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

    <div class="container">
        <!-- Cột Trái: Trình phát Video & Chi tiết Video -->
        <div>
            <div class="player-wrapper">
                <c:choose>
                    <c:when test="${video.poster != null && video.poster.startsWith('http')}">
                        <c:url value="${video.poster}" var="posterImg"/>
                    </c:when>
                    <c:when test="${video.poster != null && !empty video.poster}">
                        <c:url value="/image?fname=${video.poster}" var="posterImg"/>
                    </c:when>
                    <c:otherwise>
                        <c:url value="https://placehold.co/800x450?text=HCMUTE+Video" var="posterImg"/>
                    </c:otherwise>
                </c:choose>

                <!-- Trình phát HTML5 Video Player với Fallback demo video -->
                <video controls autoplay poster="${posterImg}">
                    <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                </video>
            </div>

            <div class="video-details">
                <h1 class="video-title">${video.title}</h1>
                <div class="meta-bar">
                    <div class="uploader-info">
                        <div class="avatar-circle">
                            ${video.user != null && video.user.fullName != null ? video.user.fullName.substring(0, 1) : 'U'}
                        </div>
                        <div>
                            <div class="uploader-name">
                                ${video.user != null ? (video.user.fullName != null ? video.user.fullName : video.user.userName) : 'Quản trị viên HCMUTE'}
                            </div>
                            <div class="uploader-role">
                                Thể loại: <b>${video.category != null ? video.category.categoryname : 'Công nghệ thông tin'}</b>
                            </div>
                        </div>
                    </div>
                    <div class="video-stats">
                        <div class="stat-badge">&#128065; ${video.views} Lượt xem</div>
                        <div class="stat-badge">&#127916; ID: ${video.videoId}</div>
                    </div>
                </div>

                <div class="description-box">
                    <p style="font-weight: 600; color: #f1f5f9; margin-top: 0;">Mô tả chi tiết:</p>
                    ${video.description != null ? video.description : 'Không có mô tả chi tiết cho video này.'}
                </div>

                <div class="actions-bar">
                    <a href="<c:url value="/video"/>" class="btn-action btn-primary">&larr; Về trang Video Của Tôi</a>
                    <a href="<c:url value="/home"/>" class="btn-action">&larr; Về Trang Chủ</a>
                    <button type="button" class="btn-action" onclick="alert('Đã lưu video vào danh sách yêu thích!');">&#9733; Yêu thích</button>
                    <button type="button" class="btn-action" onclick="navigator.clipboard.writeText(window.location.href); alert('Đã sao chép liên kết video!');">&#128279; Chia sẻ liên kết</button>
                </div>
            </div>
        </div>

        <!-- Cột Phải: Video Đề Xuất & Top Video Mới Nhất -->
        <div class="sidebar">
            <h3 class="sidebar-title">Video Đề Xuất Khác</h3>
            <div class="related-list">
                <c:forEach items="${relatedVideos}" var="rv">
                    <c:if test="${rv.videoId != video.videoId}">
                        <a href="<c:url value="/video/detail?id=${rv.videoId}"/>" class="related-item">
                            <div class="related-thumb">
                                <c:choose>
                                    <c:when test="${rv.poster != null && rv.poster.startsWith('http')}">
                                        <c:url value="${rv.poster}" var="thumbUrl"/>
                                    </c:when>
                                    <c:when test="${rv.poster != null && !empty rv.poster}">
                                        <c:url value="/image?fname=${rv.poster}" var="thumbUrl"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="https://placehold.co/120x75?text=Video" var="thumbUrl"/>
                                    </c:otherwise>
                                </c:choose>
                                <img src="${thumbUrl}" alt="${rv.title}" onerror="this.src='https://placehold.co/120x75?text=Video';"/>
                            </div>
                            <div class="related-info">
                                <div class="related-title">${rv.title}</div>
                                <div class="related-meta">&#128065; ${rv.views} lượt xem</div>
                            </div>
                        </a>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
