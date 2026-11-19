<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${video.title} - Ph&#225;t Video HCMUTE" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<style>
.vd-container { max-width: 1300px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 380px; gap: 30px; }
@media (max-width: 992px) { .vd-container { grid-template-columns: 1fr; } }
.player-wrapper { background: #000; border-radius: 12px; overflow: hidden; position: relative; width: 100%; aspect-ratio: 16/9; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
.player-wrapper video { width: 100%; height: 100%; object-fit: contain; }
.video-details { margin-top: 20px; background: #1e293b; padding: 24px; border-radius: 12px; border: 1px solid #334155; }
.video-title { font-size: 22px; font-weight: 700; margin: 0 0 14px 0; color: #fff; line-height: 1.4; }
.meta-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #334155; padding-bottom: 16px; margin-bottom: 18px; flex-wrap: wrap; gap: 10px; font-size: 14px; color: #94a3b8; }
.uploader-info { display: flex; align-items: center; gap: 12px; }
.avatar-circle { width: 42px; height: 42px; border-radius: 50%; background: #3b82f6; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; font-size: 16px; }
.uploader-name { font-weight: 600; color: #f1f5f9; }
.uploader-role { font-size: 12px; color: #64748b; }
.stat-badge { background: #0f172a; padding: 6px 14px; border-radius: 20px; border: 1px solid #334155; font-size: 13px; color: #38bdf8; }
.description-box { font-size: 14px; line-height: 1.6; color: #cbd5e1; white-space: pre-line; }
.sidebar { background: #1e293b; padding: 20px; border-radius: 12px; border: 1px solid #334155; height: fit-content; }
.sidebar-title { font-size: 17px; font-weight: 700; color: #fff; margin-top: 0; margin-bottom: 18px; border-left: 3px solid #38bdf8; padding-left: 10px; }
.related-item { display: flex; gap: 12px; text-decoration: none; color: inherit; margin-bottom: 16px; }
.related-item:hover { opacity: 0.85; }
.related-thumb { width: 120px; height: 75px; border-radius: 6px; overflow: hidden; flex-shrink: 0; background: #000; }
.related-thumb img { width: 100%; height: 100%; object-fit: cover; }
.related-title { font-size: 13px; font-weight: 600; color: #f1f5f9; line-height: 1.3; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.related-meta { font-size: 11px; color: #64748b; }
</style>

<div class="vd-container">
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
            <video controls autoplay poster="${posterImg}">
                <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                Tr&#236;nh duy&#7879;t c&#7911;a b&#7841;n kh&#244;ng h&#7895; tr&#7907; th&#7867; video HTML5.
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
                            ${video.user != null ? (video.user.fullName != null ? video.user.fullName : video.user.userName) : 'Qu&#7843;n tr&#7883; vi&#234;n HCMUTE'}
                        </div>
                        <div class="uploader-role">
                            Th&#7875; lo&#7841;i: <b>${video.category != null ? video.category.categoryname : 'C&#244;ng ngh&#7879; th&#244;ng tin'}</b>
                        </div>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <div class="stat-badge">&#128065; ${video.views} L&#432;&#7907;t xem</div>
                    <div class="stat-badge">&#127916; ID: ${video.videoId}</div>
                </div>
            </div>

            <div class="description-box">
                <p style="font-weight: 600; color: #f1f5f9; margin-top: 0;">M&#244; t&#7843; chi ti&#7871;t:</p>
                ${video.description != null ? video.description : 'Kh&#244;ng c&#243; m&#244; t&#7843; chi ti&#7871;t cho video n&#224;y.'}
            </div>

            <div class="d-flex gap-2 flex-wrap mt-4">
                <a href="<c:url value='/video'/>" class="btn btn-primary">&larr; V&#7873; trang Video C&#7911;a T&#244;i</a>
                <a href="<c:url value='/home'/>" class="btn btn-secondary">&larr; V&#7873; Trang Ch&#7911;</a>
                <button type="button" class="btn btn-outline-warning" onclick="navigator.clipboard.writeText(window.location.href); alert('&#272;&#227; sao ch&#233;p li&#234;n k&#7871;t video!');">&#128279; Chia s&#7867; li&#234;n k&#7871;t</button>
            </div>
        </div>
    </div>

    <div class="sidebar">
        <h3 class="sidebar-title">Video &#272;&#7873; Xu&#7845;t Kh&#225;c</h3>
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
                    <div>
                        <div class="related-title">${rv.title}</div>
                        <div class="related-meta">&#128065; ${rv.views} l&#432;&#7907;t xem</div>
                    </div>
                </a>
            </c:if>
        </c:forEach>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
