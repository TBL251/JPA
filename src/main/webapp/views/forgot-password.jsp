<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Qu&#234;n M&#7853;t Kh&#7849;u - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-warning bg-opacity-10 text-warning rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-shield-lock-fill fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">Qu&#234;n M&#7853;t Kh&#7849;u</h3>
                        <p class="text-muted small mb-0">H&#7879; th&#7889;ng s&#7869; g&#7917;i m&#227; OTP qua email &#273;&#7875; b&#7841;n &#273;&#7863;t l&#7841;i m&#7853;t kh&#7849;u</p>
                    </div>

                    <c:if test="${not empty alert}">
                        <div class="alert alert-danger d-flex align-items-center mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2 flex-shrink-0"></i>
                            <div>${alert}</div>
                        </div>
                    </c:if>

                    <form action="<c:url value='/forgot-password'/>" method="post" class="needs-validation" novalidate>
                        <div class="mb-4">
                            <label for="email" class="form-label fw-semibold">&#272;&#7883;a ch&#7881; Email &#273;&#227; &#273;&#259;ng k&#253; <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="${email}" placeholder="example@gmail.com"
                                       required pattern="^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$" autofocus>
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#7883;a ch&#7881; email h&#7907;p l&#7879; (v&#237; d&#7909;: ten@gmail.com).</div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-warning w-100 py-2 fw-semibold text-dark">
                            <i class="bi bi-send me-1"></i>G&#7917;i M&#227; X&#225;c Nh&#7853;n OTP
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-2 border-top">
                        <span class="text-muted small">&#272;&#227; nh&#7899; l&#7841;i m&#7853;t kh&#7849;u?</span>
                        <a href="<c:url value='/login'/>" class="text-primary text-decoration-none small fw-semibold ms-1">
                            Quay l&#7841;i &#272;&#259;ng nh&#7853;p
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
