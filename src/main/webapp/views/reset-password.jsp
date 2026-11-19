<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="&#272;&#7863;t L&#7841;i M&#7853;t Kh&#7849;u - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-info bg-opacity-10 text-info rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-key-fill fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">&#272;&#7863;t L&#7841;i M&#7853;t Kh&#7849;u</h3>
                        <p class="text-muted small mb-0">Nh&#7853;p m&#227; OTP v&#224; thi&#7871;t l&#7853;p m&#7853;t kh&#7849;u m&#7899;i</p>
                    </div>

                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2 flex-shrink-0"></i>
                            <div>${alert}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="alert alert-success d-flex align-items-center mb-3" role="alert">
                            <i class="bi bi-check-circle-fill me-2 flex-shrink-0"></i>
                            <div>${message}</div>
                        </div>
                    </c:if>

                    <form action="<c:url value='/reset-password'/>" method="post" class="needs-validation" id="resetPasswordForm" novalidate>
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">&#272;&#7883;a ch&#7881; Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${email}" placeholder="example@gmail.com" required>
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#7883;a ch&#7881; email.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="otp" class="form-label fw-semibold">M&#227; OTP (6 ch&#7919; s&#7889;) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control text-center fw-bold fs-4"
                                   id="otp" name="otp" maxlength="6" pattern="^[0-9]{6}$"
                                   placeholder="------" required autofocus>
                            <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#250;ng 6 ch&#7919; s&#7889; m&#227; OTP.</div>
                        </div>

                        <div class="mb-3">
                            <label for="newPassword" class="form-label fw-semibold">M&#7853;t kh&#7849;u m&#7899;i <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="newPassword" name="newPassword"
                                       placeholder="T&#7889;i thi&#7875;u 6 k&#253; t&#7921;" required minlength="6">
                                <div class="invalid-feedback">M&#7853;t kh&#7849;u m&#7899;i ph&#7843;i c&#243; t&#7889;i thi&#7875;u 6 k&#253; t&#7921;.</div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label fw-semibold">X&#225;c nh&#7853;n m&#7853;t kh&#7849;u m&#7899;i <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                       placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u m&#7899;i" required minlength="6">
                                <div class="invalid-feedback">X&#225;c nh&#7853;n m&#7853;t kh&#7849;u ph&#7843;i kh&#7899;p v&#7899;i m&#7853;t kh&#7849;u m&#7899;i.</div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i>C&#7853;p Nh&#7853;t M&#7853;t Kh&#7849;u M&#7899;i
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-2 border-top">
                        <a href="<c:url value='/login'/>" class="text-muted text-decoration-none small">
                            <i class="bi bi-arrow-left me-1"></i>Quay l&#7841;i &#272;&#259;ng nh&#7853;p
                        </a>
                        <span class="text-muted mx-2">|</span>
                        <a href="<c:url value='/forgot-password'/>" class="text-primary text-decoration-none small">
                            G&#7917;i l&#7841;i m&#227; OTP
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const newPasswordInput = document.getElementById("newPassword");
    const confirmPasswordInput = document.getElementById("confirmPassword");
    function validatePasswordMatch() {
        if (confirmPasswordInput.value !== newPasswordInput.value) {
            confirmPasswordInput.setCustomValidity("M&#7853;t kh&#7849;u kh&#244;ng kh&#7899;p!");
        } else {
            confirmPasswordInput.setCustomValidity("");
        }
    }
    newPasswordInput.addEventListener("input", validatePasswordMatch);
    confirmPasswordInput.addEventListener("input", validatePasswordMatch);
});
</script>

<jsp:include page="/views/layout/footer.jsp"/>
