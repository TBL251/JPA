<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Danh S&#225;ch Danh M&#7909;c - Admin" scope="request"/>
<jsp:include page="/views/layout/admin-header.jsp"/>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="fw-bold text-dark mb-0">Qu&#7843;n l&#253; Danh m&#7909;c (JPA 3.0 &amp; Hibernate)</h4>
    <a href="<c:url value='/admin/category/add'/>" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Th&#234;m Danh m&#7909;c m&#7899;i
    </a>
</div>

<c:if test="${not empty message}">
    <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i><div>${message}</div>
    </div>
</c:if>
<c:if test="${not empty alert}">
    <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><div>${alert}</div>
    </div>
</c:if>

<div class="card border-0 shadow-sm">
    <div class="table-responsive">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th style="width: 60px;">STT</th>
                    <th style="width: 150px;">H&#236;nh &#7843;nh</th>
                    <th>T&#234;n Danh m&#7909;c</th>
                    <th style="width: 140px;">Tr&#7841;ng th&#225;i</th>
                    <th style="width: 150px;">H&#224;nh &#273;&#7897;ng</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty listcate}">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">
                                Ch&#432;a c&#243; danh m&#7909;c n&#224;o trong CSDL. B&#7845;m v&#224;o <b>"+ Th&#234;m Danh m&#7909;c m&#7899;i"</b> &#273;&#7875; t&#7841;o!
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
                                            <c:set var="imgUrl" value="https://placehold.co/120x90?text=No+Image"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img style="width:120px;height:90px;object-fit:cover;border-radius:6px;" src="${imgUrl}" alt="${cate.categoryname}"
                                         onerror="this.onerror=null;this.src='https://placehold.co/120x90?text=No+Image';"/>
                                </td>
                                <td>
                                    <strong>${cate.categoryname}</strong>
                                    <div class="text-muted small mt-1">ID: ${cate.categoryid}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cate.status == 1}">
                                            <span class="badge bg-success-subtle text-success">&#9679; Ho&#7841;t &#273;&#7897;ng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger">&#9679; Kh&#243;a</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="<c:url value='/admin/category/edit?id=${cate.categoryid}'/>" class="btn btn-sm btn-outline-primary me-1">S&#7917;a</a>
                                    <a href="<c:url value='/admin/category/delete?id=${cate.categoryid}'/>" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('B&#7841;n c&#243; ch&#7855;c ch&#7855;n mu&#7889;n x&#243;a danh m&#7909;c n&#224;y?');">X&#243;a</a>
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
