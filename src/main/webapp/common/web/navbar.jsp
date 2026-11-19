<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark py-2 shadow-sm" style="background-color: #0f172a !important;">
    <div class="container-fluid px-lg-4">
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-info" href="<c:url value='/home'/>">
            <i class="bi bi-play-circle-fill fs-4 text-primary"></i>
            <span>HCMUTE JPA</span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#webNav"
                aria-controls="webNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="webNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/home'/>">
                        <i class="bi bi-house-door me-1"></i>Trang Chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-light" href="<c:url value='/video'/>">
                        <i class="bi bi-collection-play me-1"></i>Video Của Tôi
                    </a>
                </li>

                <c:if test="${not empty sessionScope.account && (sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2)}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-warning" href="#" id="adminWebDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-shield-lock me-1"></i>Quản Trị
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark shadow" aria-labelledby="adminWebDropdown">
                            <li><a class="dropdown-item" href="<c:url value='/admin/categories'/>"><i class="bi bi-list-ul me-2"></i>Quản Lý Danh Mục</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/admin/category/add'/>"><i class="bi bi-plus-circle me-2"></i>Thêm Danh Mục Mới</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<c:url value='/admin/videos'/>"><i class="bi bi-film me-2"></i>Quản Lý Videos</a></li>
                            <li><a class="dropdown-item" href="<c:url value='/admin/video/add'/>"><i class="bi bi-cloud-upload me-2"></i>Thêm Video Mới</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 text-light" href="#" id="userNavMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account.avatar}">
                                        <img src="${sessionScope.account.avatar}" alt="Avatar" class="rounded-circle border border-primary" style="width: 32px; height: 32px; object-fit: cover;">
                                    </c:when>
                                    <c:when test="${not empty sessionScope.account.images}">
                                        <img src="${sessionScope.account.images}" alt="Avatar" class="rounded-circle border border-primary" style="width: 32px; height: 32px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.85rem; font-weight: bold;">
                                            <c:out value="${not empty sessionScope.account.userName ? sessionScope.account.userName.substring(0, 1).toUpperCase() : (not empty sessionScope.account.username ? sessionScope.account.username.substring(0, 1).toUpperCase() : 'U')}" />
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <span>${not empty sessionScope.account.fullName ? sessionScope.account.fullName : (not empty sessionScope.account.fullname ? sessionScope.account.fullname : (not empty sessionScope.account.userName ? sessionScope.account.userName : sessionScope.account.username))}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userNavMenu">
                                <li class="dropdown-header text-muted small">Tài khoản: @${sessionScope.account.username}</li>
                                <li>
                                    <a class="dropdown-item" href="<c:url value='/user/profile'/>">
                                        <i class="bi bi-person-circle me-2 text-primary"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <c:if test="${sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2}">
                                    <li>
                                        <a class="dropdown-item" href="<c:url value='/admin/categories'/>">
                                            <i class="bi bi-speedometer2 me-2 text-warning"></i>Trang quản trị
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="<c:url value='/logout'/>">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-light btn-sm px-3" href="<c:url value='/login'/>">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng Nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3" href="<c:url value='/register'/>">
                                <i class="bi bi-person-plus me-1"></i>Đăng Ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
