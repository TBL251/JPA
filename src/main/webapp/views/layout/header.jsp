<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${not empty pageTitle ? pageTitle : 'HCMUTE JPA'}</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold text-info" href="<c:url value='/home'/>">&#9654; HCMUTE JPA</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
      <ul class="navbar-nav me-auto">
        <li class="nav-item"><a class="nav-link text-light" href="<c:url value='/home'/>">Trang Ch&#7911;</a></li>
        <li class="nav-item"><a class="nav-link text-light" href="<c:url value='/video'/>">Video</a></li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <li class="nav-item"><a class="nav-link text-light" href="<c:url value='/profile'/>"><i class="bi bi-person-circle me-1"></i>${sessionScope.user.userName}</a></li>
            <c:if test="${sessionScope.user.role == 1}">
              <li class="nav-item"><a class="nav-link text-warning" href="<c:url value='/admin/categories'/>"><i class="bi bi-gear me-1"></i>Admin</a></li>
            </c:if>
            <li class="nav-item"><a class="btn btn-outline-light btn-sm px-3 ms-2 nav-link" href="<c:url value='/logout'/>">&#272;&#259;ng Xu&#7845;t</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item"><a class="btn btn-outline-light btn-sm px-3 me-2 nav-link" href="<c:url value='/login'/>">&#272;&#259;ng Nh&#7853;p</a></li>
            <li class="nav-item"><a class="btn btn-primary btn-sm px-3 nav-link" href="<c:url value='/register'/>">&#272;&#259;ng K&#253;</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>
<main class="flex-grow-1">
