<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Video - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<style>
.vl-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; flex-wrap: wrap; gap: 10px; }
.page-title { font-size: 24px; font-weight: 700; color: #0f172a; margin: 0; }
.info-pill { background: #e0f2fe; color: #0369a1; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 500; }
.notice-banner { background: #eff6ff; border-left: 4px solid #3b82f6; padding: 12px 18px; border-radius: 6px; margin-bottom: 25px; font-size: 14px; color: #1e40af; }
.video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px; margin-bottom: 40px; }
.video-card { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
.video-card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
.poster-box { position: relative; width: 100%; height: 190px; background: #000; overflow: hidden; }
.poster-box img { width: 100%; height: 100%; object-fit: cover; opacity: 0.92; transition: opacity 0.2s; }
.video-card:hover .poster-box img { opacity: 1; }
.play-btn { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 48px; height: 48px; background: rgba(37,99,235,0.9); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
.video-content { padding: 18px; flex-grow: 1; display: flex; flex-direction: column; }
.video-heading { font-size: 16px; font-weight: 700; margin-bottom: 8px; line-height: 1.4; }
.video-heading a { color: #0f172a; text-decoration: none; }
.video-heading a:hover { color: #2563eb; text-decoration: underline; }
.video-desc { font-size: 13px; color: #64748b; margin-bottom: 15px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.meta-row { margin-top: auto; display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: #64748b; padding-top: 12px; border-top: 1px solid #f1f5f9; }
.tag-view { background: #f0fdf4; color: #166534; padding: 3px 8px; border-radius: 4px; font-weight: 600; }
.tag-user { background: #f8fafc; color: #475569; padding: 3px 8px; border-radius: 4px; }
.pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin: 40px 0; }
.page-link-custom { display: inline-flex; justify-content: center; align-items: center; min-width: 38px; height: 38px; padding: 0 12px; border-radius: 6px; border: 1px solid #cbd5e1; background: #fff; color: #334155; text-decoration: none; font-weight: 600; font-size: 14px; }
.page-link-custom:hover { background: #f1f5f9; }
.page-link-custom.active { background: #2563eb; border-color: #2563eb; color: #fff; }
.page-link-custom.disabled { opacity: 0.5; pointer-events: none; }
.empty-state { text-align: center; padding: 60px 20px; background: #fff; border-radius: 12px; }
</style>

<div class="vl-container">
    <div class="page-header">
        <div>
            <h1 class="page-title">T&#7845;t C&#7843; Videos C&#7911;a User</h1>
            <div style="color: #64748b; font-size: 14px; margin-top: 4px;">Hi&#7875;n th&#7883; ph&#226;n trang 6 video/trang</div>
        </div>
        <div class="info-pill">
            T&#7893;ng c&#7897;ng: <b>${totalVideos}</b> video | Trang <b>${currentPage}</b> / <b>${totalPages}</b>
        </div>
    </div>

    <c:if test="${not empty infoMsg}">
        <div class="notice-banner">&#9432; ${infoMsg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty videos}">
            <div class="empty-state">
                <h3>Kh&#244;ng t&#236;m th&#7845;y video n&#224;o</h3>
                <p style="color: #64748b;">Hi&#7879;n ch&#432;a c&#243; video n&#224;o &#273;&#432;&#7907;c &#273;&#259;ng t&#7843;i.</p>
                <a href="<c:url value='/home'/>" style="color: #2563eb; font-weight: 600;">&larr; V&#7873; Trang Ch&#7911;</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="video-grid">
                <c:forEach items="${videos}" var="v">
                    <div class="video-card">
                        <div class="poster-box">
                            <c:choose>
                                <c:when test="${v.poster != null && v.poster.startsWith('http')}">
                                    <c:url value="${v.poster}" var="posterUrl"/>
                                </c:when>
                                <c:when test="${v.poster != null && !empty v.poster}">
                                    <c:url value="/image?fname=${v.poster}" var="posterUrl"/>
                                </c:when>
                                <c:otherwise>
                                    <c:url value="https://placehold.co/320x190?text=Video" var="posterUrl"/>
                                </c:otherwise>
                            </c:choose>
                            <a href="<c:url value="/video/detail?id=${v.videoId}"/>">
                                <img src="${posterUrl}" alt="${v.title}" onerror="this.src='https://placehold.co/320x190?text=Video';"/>
                                <div class="play-btn">&#9658;</div>
                            </a>
                        </div>
                        <div class="video-content">
                            <div class="video-heading">
                                <a href="<c:url value="/video/detail?id=${v.videoId}"/>" title="${v.title}">${v.title}</a>
                            </div>
                            <div class="video-desc">${v.description != null ? v.description : 'Kh&#244;ng c&#243; m&#244; t&#7843; cho video n&#224;y.'}</div>
                            <div class="meta-row">
                                <span class="tag-view">&#128065; ${v.views} l&#432;&#7907;t xem</span>
                                <span class="tag-user">&#128100; ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Qu&#7843;n tr&#7883; vi&#234;n'}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <a href="<c:url value="/video?page=${currentPage - 1}"/>" class="page-link-custom ${currentPage <= 1 ? 'disabled' : ''}">&laquo; Tr&#432;&#7899;c</a>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="<c:url value="/video?page=${i}"/>" class="page-link-custom ${currentPage == i ? 'active' : ''}">${i}</a>
                    </c:forEach>
                    <a href="<c:url value="/video?page=${currentPage + 1}"/>" class="page-link-custom ${currentPage >= totalPages ? 'disabled' : ''}">Sau &raquo;</a>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
