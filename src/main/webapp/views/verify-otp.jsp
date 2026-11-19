<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="X&#225;c Th&#7921; M&#227; OTP - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-shield-check fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">X&#225;c Th&#7921; M&#227; OTP</h3>
                        <p class="text-muted small mb-0">Nh&#7853;p m&#227; x&#225;c th&#7921; 6 ch&#7919; s&#7889; g&#7917;i t&#7899;i email c&#7911;a b&#7841;n</p>
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

                    <form action="<c:url value='/verify-otp'/>" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">&#272;&#7883;a ch&#7881; Email &#273;&#259;ng k&#253; <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${email}" placeholder="example@gmail.com" required>
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#7883;a ch&#7881; email.</div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="otp" class="form-label fw-semibold">M&#227; x&#225;c nh&#7853;n OTP (6 ch&#7919; s&#7889;) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control text-center fw-bold fs-3"
                                   id="otp" name="otp" maxlength="6" pattern="^[0-9]{6}$"
                                   placeholder="------" required autofocus>
                            <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#250;ng 6 ch&#7919; s&#7889; m&#227; OTP.</div>
                        </div>

                        <button type="submit" class="btn btn-success w-100 py-2 fw-semibold">
                            <i class="bi bi-check-lg me-1"></i>X&#225;c Nh&#7853;n &amp; K&#237;ch Ho&#7841;t T&#224;i Kho&#7843;n
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-2 border-top">
                        <span class="text-muted small">Ch&#432;a nh&#7853;n &#273;&#432;&#7907;c m&#227;?</span>
                        <a href="<c:url value='/verify-otp?action=resend&email=${email}'/>" class="text-primary text-decoration-none small fw-semibold ms-1">
                            G&#7917;i l&#7841;i m&#227; OTP
                        </a>
                        <div class="mt-2">
                            <a href="<c:url value='/login'/>" class="text-muted text-decoration-none small">
                                <i class="bi bi-arrow-left me-1"></i>Quay l&#7841;i &#272;&#259;ng nh&#7853;p
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
