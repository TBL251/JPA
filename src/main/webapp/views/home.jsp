<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Trang Ch&#7911; - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<style>
.hero { text-align: center; padding: 45px 20px; background: linear-gradient(135deg, #1e293b, #0f172a); color: #fff; }
.hero h1 { font-size: 32px; margin-bottom: 12px; }
.hero p { color: #94a3b8; font-size: 16px; margin-bottom: 24px; }
.home-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
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
.cate-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }
.cate-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
.cate-card img { width: 100%; height: 170px; object-fit: cover; }
.cate-body { padding: 16px; }
.cate-title { font-size: 16px; font-weight: 600; margin-bottom: 8px; color: #0f172a; }
.badge-views { background: #eff6ff; color: #1e40af; }
.badge-user { background: #f1f5f9; color: #475569; }
.badge-success { background: #dcfce7; color: #166534; }
.badge-danger { background: #fee2e2; color: #991b1b; }
</style>

<div class="hero">
    <h1>N&#7873;n T&#7843;ng &#272;a Ph&#432;&#417;ng Ti&#7879;n &amp; Mua S&#7855;m JPA 3.0</h1>
    <p>Ph&#225;t tri&#7875;n b&#7903;i Khoa CNTT - &#272;&#7841;i h&#7885;c S&#432; ph&#7841;m K&#7929; thu&#7853;t TP.HCM (HCMUTE)</p>
    <div style="display: flex; justify-content: center; gap: 15px;">
        <a href="<c:url value='/video'/>" class="btn btn-success px-4 py-2">Xem T&#7845;t C&#7843; Video &rarr;</a>
        <c:if test="${empty sessionScope.account}">
            <a href="<c:url value='/register'/>" class="btn btn-primary px-4 py-2">&#272;&#259;ng K&#253; T&#224;i Kho&#7843;n &rarr;</a>
        </c:if>
    </div>
</div>

<div class="home-container">
    <div class="section-header">
        <h2 class="section-title">10 Video M&#7899;i Nh&#7845;t</h2>
        <a href="<c:url value='/video'/>" class="view-all-link">Xem t&#7845;t c&#7843; video &rarr;</a>
    </div>

    <div class="video-grid">
        <c:choose>
            <c:when test="${empty topVideos}">
                <p style="grid-column: 1/-1; text-align: center; color: #64748b; padding: 40px;">
                    Ch&#432;a c&#243; video n&#224;o trong h&#7879; th&#7889;ng.
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
                                <a href="<c:url value="/video/detail?id=${v.videoId}"/>" title="${v.title}">${v.title}</a>
                            </div>
                            <div class="video-meta">
                                <span class="badge badge-views">&#128065; ${v.views} l&#432;&#7907;t xem</span>
                                <span class="badge badge-user">&#128100; ${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Qu&#7843;n tr&#7883; vi&#234;n'}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section-header">
        <h2 class="section-title">Danh S&#225;ch Danh M&#7909;c S&#7843;n Ph&#7849;m</h2>
    </div>

    <div class="cate-grid">
        <c:choose>
            <c:when test="${empty listcate}">
                <p style="grid-column: 1/-1; text-align: center; color: #64748b; padding: 40px;">
                    Ch&#432;a c&#243; danh m&#7909;c n&#224;o.
                </p>
            </c:when>
            <c:otherwise>
                <c:forEach items="${listcate}" var="c">
                    <div class="cate-card">
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
                        <div class="cate-body">
                            <div class="cate-title">${c.categoryname}</div>
                            <c:choose>
                                <c:when test="${c.status == 1}">
                                    <span class="badge badge-success">&#10003; Ho&#7841;t &#273;&#7897;ng</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">&#9679; T&#7841;m kh&#243;a</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
