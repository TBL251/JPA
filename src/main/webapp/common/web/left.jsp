<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="card shadow-sm border-0 mb-4">
    <div class="card-header bg-primary text-white fw-semibold">
        <i class="bi bi-grid-fill me-2"></i>Danh Mục
    </div>
    <div class="list-group list-group-flush">
        <a href="<c:url value='/home'/>" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
            <span><i class="bi bi-house me-2"></i>Tất cả danh mục</span>
        </a>
        <c:forEach var="item" items="${categoryList}">
            <a href="<c:url value='/home?cateid=${item.categoryId}'/>" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${item.categoryId == selectedCateId ? 'active' : ''}">
                <span><i class="bi bi-folder2-open me-2"></i>${item.categoryname}</span>
            </a>
        </c:forEach>
    </div>
</div>
