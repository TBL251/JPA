<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="app-footer py-3 mt-auto text-secondary" style="background-color: #0f172a; border-top: 1px solid #1e293b;">
    <div class="container text-center">
        <div class="row align-items-center">
            <div class="col-md-6 text-md-start mb-2 mb-md-0">
                <p class="mb-0 small">
                    &copy; 2026 <strong>HCMUTE</strong> - Lập Trình Web (JPA 3.0 & SiteMesh 3)
                </p>
            </div>
            <div class="col-md-6 text-md-end small">
                <span class="me-3">Layout: <code>web.jsp</code></span>
                <a href="<c:url value='/home'/>" class="text-info text-decoration-none me-2">Trang Chủ</a>
                <a href="<c:url value='/profile'/>" class="text-info text-decoration-none">Hồ Sơ</a>
            </div>
        </div>
    </div>
</footer>
