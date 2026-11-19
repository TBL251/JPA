<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="X&#225;c Th&#7921; OTP Email M&#7899;i - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-envelope-check-fill fs-2"></i>
                        </div>
                        <h4 class="fw-bold text-dark mb-1">X&#225;c Th&#7921; Email M&#7899;i</h4>
                        <p class="text-muted small mb-0">H&#7879; th&#7889;ng &#273;&#227; g&#7917;i m&#227; OTP x&#225;c nh&#7853;n &#273;&#7871;n &#273;&#7883;a ch&#7881;:</p>
                        <div class="badge bg-light text-primary border border-primary border-opacity-25 fs-6 mt-2 px-3 py-2">
                            ${pendingEmail}
                        </div>
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

                    <form action="<c:url value='/profile/verify-otp'/>" method="post" class="needs-validation" novalidate>
                        <div class="mb-4">
                            <label for="otp" class="form-label fw-semibold">Nh&#7853;p m&#227; OTP (6 ch&#7919; s&#7889;) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control text-center fw-bold fs-3"
                                   id="otp" name="otp" maxlength="6" pattern="^[0-9]{6}$"
                                   placeholder="------" required autofocus>
                            <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#250;ng 6 ch&#7919; s&#7889; m&#227; OTP nh&#7853;n &#273;&#432;&#7907;c trong email.</div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i>X&#225;c Nh&#7853;n &amp; C&#7853;p Nh&#7853;t H&#7891; S&#417;
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <span class="text-muted small">Ch&#432;a nh&#7853;n &#273;&#432;&#7907;c m&#227;?</span>
                        <a href="<c:url value='/profile/resend-otp'/>" class="text-primary text-decoration-none small fw-semibold ms-1">
                            G&#7917;i l&#7841;i m&#227; OTP
                        </a>
                        <div class="mt-2">
                            <a href="<c:url value='/profile'/>" class="text-secondary text-decoration-none small">
                                <i class="bi bi-arrow-left me-1"></i>H&#7911;y b&#7887; &amp; Quay l&#7841;i H&#7891; s&#417;
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
