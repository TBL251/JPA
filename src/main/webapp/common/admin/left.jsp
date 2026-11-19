<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card border-0 shadow-sm rounded-3 mb-3">
    <div class="card-header bg-dark text-white fw-semibold small text-uppercase py-2">
        <i class="bi bi-grid-fill me-2 text-warning"></i>Bảng Điều Khiển
    </div>
    <div class="list-group list-group-flush small">
        <a href="<c:url value='/admin/categories'/>" class="list-group-item list-group-item-action d-flex align-items-center">
            <i class="bi bi-folder me-2 text-primary"></i>Quản lý Danh mục
        </a>
        <a href="<c:url value='/admin/category/add'/>" class="list-group-item list-group-item-action d-flex align-items-center ps-4">
            <i class="bi bi-plus-circle me-2 text-success"></i>+ Thêm Danh mục
        </a>
        <a href="<c:url value='/admin/videos'/>" class="list-group-item list-group-item-action d-flex align-items-center">
            <i class="bi bi-film me-2 text-primary"></i>Quản lý Videos
        </a>
        <a href="<c:url value='/admin/video/add'/>" class="list-group-item list-group-item-action d-flex align-items-center ps-4">
            <i class="bi bi-cloud-upload me-2 text-info"></i>+ Thêm Video mới
        </a>
        <a href="<c:url value='/profile'/>" class="list-group-item list-group-item-action d-flex align-items-center">
            <i class="bi bi-person-gear me-2 text-secondary"></i>Hồ sơ Admin
        </a>
        <a href="<c:url value='/home'/>" class="list-group-item list-group-item-action d-flex align-items-center">
            <i class="bi bi-arrow-left me-2 text-muted"></i>Về Trang Người Dùng
        </a>
    </div>
</div>
