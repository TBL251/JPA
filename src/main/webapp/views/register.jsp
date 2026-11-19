<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="&#272;&#259;ng K&#253; T&#224;i Kho&#7843;n - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-6">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-person-plus-fill fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">&#272;&#259;ng K&#253; T&#224;i Kho&#7843;n</h3>
                        <p class="text-muted small mb-0">X&#225;c th&#7921;c k&#237;ch ho&#7841;t t&#224;i kho&#7843;n b&#7857;ng m&#227; OTP g&#7917;i qua Email</p>
                    </div>

                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2 flex-shrink-0"></i>
                            <div>${alert}</div>
                        </div>
                    </c:if>

                    <div class="alert alert-info py-2 small d-flex align-items-center mb-4">
                        <i class="bi bi-info-circle-fill me-2 flex-shrink-0 fs-5"></i>
                        <div>M&#227; OTP 6 ch&#7919; s&#7889; s&#7869; &#273;&#432;&#7907;c g&#7917;i t&#7921; &#273;&#7897;ng &#273;&#7871;n email c&#7911;a b&#7841;n &#273;&#7875; k&#237;ch ho&#7841;t t&#224;i kho&#7843;n.</div>
                    </div>

                    <form action="<c:url value='/register'/>" method="post" class="needs-validation" id="registerForm" novalidate>
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">T&#234;n &#273;&#259;ng nh&#7853;p <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       value="${username}" placeholder="V&#237; d&#7909;: nguyenvana"
                                       required minlength="3" maxlength="30" pattern="^[a-zA-Z0-9_]{3,30}$">
                                <div class="invalid-feedback">T&#234;n &#273;&#259;ng nh&#7853;p t&#7915; 3-30 k&#253; t&#7921;, ch&#7881; g&#7891;m ch&#7919; c&#225;i, s&#7889; v&#224; d&#7845;u g&#7841;ch d&#432;&#7899;i (_).</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label fw-semibold">&#272;&#7883;a ch&#7881; Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${email}" placeholder="example@gmail.com"
                                       required pattern="^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$">
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#7883;a ch&#7881; email h&#7907;p l&#7879;.</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="fullname" class="form-label fw-semibold">H&#7885; v&#224; t&#234;n <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                <input type="text" class="form-control" id="fullname" name="fullname"
                                       value="${fullname}" placeholder="Nguy&#7877;n V&#259;n A" required minlength="2" maxlength="100">
                                <div class="invalid-feedback">H&#7885; v&#224; t&#234;n kh&#244;ng &#273;&#432;&#7907;c &#273;&#7875; tr&#7889;ng (t&#7889;i thi&#7875;u 2 k&#253; t&#7921;).</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label fw-semibold">S&#7889; &#273;i&#7879;n tho&#7841;i</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel" class="form-control" id="phone" name="phone"
                                       value="${phone}" placeholder="0901234567" pattern="^(0[3|5|7|8|9])[0-9]{8}$">
                                <div class="invalid-feedback">S&#7889; &#273;i&#7879;n tho&#7841;i Vi&#7879;t Nam g&#7891;m 10 ch&#7919; s&#7889; (b&#7855;t &#273;&#7847;u b&#7857;ng 03, 05, 07, 08, 09).</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold">M&#7853;t kh&#7849;u <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="T&#7889;i thi&#7875;u 6 k&#253; t&#7921;" required minlength="6">
                                <div class="invalid-feedback">M&#7853;t kh&#7849;u ph&#7843;i c&#243; &#237;t nh&#7845;t 6 k&#253; t&#7921;.</div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="confirmPassword" class="form-label fw-semibold">X&#225;c nh&#7853;n m&#7853;t kh&#7849;u <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                       placeholder="Nh&#7853;p l&#7841;i m&#7853;t kh&#7849;u" required minlength="6">
                                <div class="invalid-feedback" id="confirmPasswordFeedback">Vui l&#242;ng x&#225;c nh&#7853;n m&#7853;t kh&#7849;u kh&#7899;p v&#7899;i m&#7853;t kh&#7849;u &#7903; tr&#234;n.</div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success w-100 py-2 fw-semibold">
                            <i class="bi bi-person-check me-1"></i>&#272;&#259;ng K&#253; &amp; Nh&#7853;n M&#227; OTP
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-2 border-top">
                        <span class="text-muted small">&#272;&#227; c&#243; t&#224;i kho&#7843;n?</span>
                        <a href="<c:url value='/login'/>" class="text-primary text-decoration-none small fw-semibold ms-1">
                            &#272;&#259;ng nh&#7853;p ngay
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const passwordInput = document.getElementById("password");
    const confirmPasswordInput = document.getElementById("confirmPassword");
    function validatePasswordMatch() {
        if (confirmPasswordInput.value !== passwordInput.value) {
            confirmPasswordInput.setCustomValidity("M&#7853;t kh&#7849;u x&#225;c nh&#7853;n kh&#244;ng kh&#7899;p!");
        } else {
            confirmPasswordInput.setCustomValidity("");
        }
    }
    passwordInput.addEventListener("input", validatePasswordMatch);
    confirmPasswordInput.addEventListener("input", validatePasswordMatch);
});
</script>

<jsp:include page="/views/layout/footer.jsp"/>
