<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="sticky-top">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark py-2 shadow-sm" style="background-color: #1e1b4b !important;">
        <div class="container-fluid px-lg-4">
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-warning" href="<c:url value='/admin/categories'/>">
                <i class="bi bi-shield-lock-fill fs-4 text-warning"></i>
                <span>HCMUTE ADMIN PORTAL</span>
            </a>

            <div class="ms-auto d-flex align-items-center gap-3">
                <a href="<c:url value='/home'/>" class="btn btn-outline-light btn-sm">
                    <i class="bi bi-box-arrow-up-right me-1"></i>Xem Trang Chủ
                </a>
                <c:if test="${not empty sessionScope.account}">
                    <span class="text-light small d-none d-md-inline">
                        Xin chào, <b>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</b>
                    </span>
                    <a href="<c:url value='/logout'/>" class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i>Đăng Xuất
                    </a>
                </c:if>
            </div>
        </div>
    </nav>
</header>
