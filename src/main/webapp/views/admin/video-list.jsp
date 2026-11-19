<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Qu&#7843;n L&#253; Video - Admin" scope="request"/>
<jsp:include page="/views/layout/admin-header.jsp"/>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold text-dark mb-0">Qu&#7843;n L&#253; Danh S&#225;ch Videos (JPA 3.0 &amp; Hibernate)</h4>
    <a href="<c:url value='/admin/video/add'/>" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Th&#234;m Video M&#7899;i (Multipart)
    </a>
</div>

<div class="card border-0 shadow-sm">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th style="width:80px;">M&#227; Video</th>
                    <th style="width:130px;">Poster</th>
                    <th>Ti&#234;u &#273;&#7873; &amp; M&#244; t&#7843;</th>
                    <th style="width:150px;">Danh m&#7909;c</th>
                    <th style="width:140px;">Ng&#432;&#7901;i &#273;&#259;ng</th>
                    <th style="width:100px;">L&#432;&#7907;t xem</th>
                    <th style="width:110px;">Tr&#7841;ng th&#225;i</th>
                    <th style="width:180px;">H&#224;nh &#273;&#7897;ng</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty listvideo}">
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">
                                Ch&#432;a c&#243; video n&#224;o. B&#7845;m v&#224;o <b>"+ Th&#234;m Video M&#7899;i"</b> &#273;&#7875; t&#7841;o m&#7899;i!
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
                                            <c:set var="pUrl" value="https://placehold.co/110x65?text=Video"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${pUrl}" alt="${v.title}" style="width:110px;height:65px;object-fit:cover;border-radius:6px;"
                                         onerror="this.src='https://placehold.co/110x65?text=Video';"/>
                                </td>
                                <td>
                                    <div class="fw-semibold">
                                        <a href="<c:url value="/video/detail?id=${v.videoId}"/>" target="_blank" class="text-dark text-decoration-none">${v.title}</a>
                                    </div>
                                    <div class="text-muted small text-truncate" style="max-width:350px;">${v.description}</div>
                                </td>
                                <td>${v.category != null ? v.category.categoryname : 'Ch&#432;a ph&#226;n lo&#7841;i'}</td>
                                <td>${v.user != null ? (v.user.fullName != null ? v.user.fullName : v.user.userName) : 'Qu&#7843;n tr&#7883; vi&#234;n'}</td>
                                <td><b>${v.views}</b></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.active}">
                                            <span class="badge bg-success-subtle text-success">&#10003; Hi&#7875;n th&#7883;</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger">&#9679; &#7848;n</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="<c:url value="/video/detail?id=${v.videoId}"/>" class="text-success text-decoration-none me-2" target="_blank">&#9658; Xem</a>
                                    <a href="<c:url value="/admin/video/edit?id=${v.videoId}"/>" class="text-primary text-decoration-none me-2">&#9998; S&#7917;a</a>
                                    <a href="<c:url value="/admin/video/delete?id=${v.videoId}"/>" class="text-danger text-decoration-none"
                                       onclick="return confirm('B&#7841;n c&#243; ch&#7855;c ch&#7855;n mu&#7889;n x&#243;a video n&#224;y?');">&#128465; X&#243;a</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/layout/admin-footer.jsp"/>
