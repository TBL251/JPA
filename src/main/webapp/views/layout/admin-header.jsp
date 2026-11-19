<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${not empty pageTitle ? pageTitle : 'Admin - HCMUTE JPA'}</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<style>
#sidebar{width:240px;min-height:100vh;background:#0f172a;position:fixed;top:0;left:0;z-index:100}
#main-content{margin-left:240px;min-height:100vh;background:#f1f5f9}
@media(max-width:768px){#sidebar{position:relative;width:100%;min-height:auto}#main-content{margin-left:0}}
</style>
</head>
<body>
<div id="sidebar" class="d-flex flex-column p-3">
  <a class="navbar-brand fw-bold text-info mb-4" href="<c:url value='/admin/categories'/>">
    <i class="bi bi-grid-3x3-gap-fill me-2"></i>Admin Panel
  </a>
  <ul class="nav flex-column gap-1">
    <li class="nav-item"><a class="nav-link text-light d-flex align-items-center gap-2" href="<c:url value='/admin/categories'/>"><i class="bi bi-folder2-open"></i>Danh M&#7909;c</a></li>
    <li class="nav-item"><a class="nav-link text-light d-flex align-items-center gap-2" href="<c:url value='/admin/videos'/>"><i class="bi bi-camera-video"></i>Video</a></li>
    <li class="nav-item mt-3"><a class="nav-link text-light d-flex align-items-center gap-2" href="<c:url value='/home'/>"><i class="bi bi-house"></i>Trang Ch&#7911;</a></li>
    <li class="nav-item"><a class="nav-link text-danger d-flex align-items-center gap-2" href="<c:url value='/logout'/>"><i class="bi bi-box-arrow-right"></i>&#272;&#259;ng Xu&#7845;t</a></li>
  </ul>
</div>
<div id="main-content">
  <nav class="navbar navbar-dark px-3 py-2 shadow-sm" style="background:#1e293b">
    <span class="navbar-brand fw-semibold text-white">${not empty pageTitle ? pageTitle : 'Admin'}</span>
    <div class="ms-auto"><a class="btn btn-sm btn-outline-light" href="<c:url value='/home'/>"><i class="bi bi-house me-1"></i>Web</a></div>
  </nav>
  <div class="p-4">
