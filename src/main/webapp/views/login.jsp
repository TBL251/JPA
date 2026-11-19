<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="&#272;&#259;ng Nh&#7853;p - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-10 col-md-8 col-lg-5">
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="d-inline-flex align-items-center justify-content-center bg-primary bg-opacity-10 text-primary rounded-circle mb-3" style="width: 56px; height: 56px;">
                            <i class="bi bi-box-arrow-in-right fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">&#272;&#259;ng Nh&#7853;p</h3>
                        <p class="text-muted small mb-0">M&#7853;t kh&#7849;u &#273;&#432;&#7907;c m&#227; h&#243;a an to&#224;n b&#7857;ng BCrypt</p>
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

                    <form action="<c:url value='/login'/>" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="username" class="form-label fw-semibold">T&#234;n &#273;&#259;ng nh&#7853;p ho&#7863;c Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="username" name="username"
                                       value="${username}" placeholder="Nh&#7853;p username ho&#7863;c email"
                                       required minlength="3">
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p t&#234;n &#273;&#259;ng nh&#7853;p ho&#7863;c email (t&#7889;i thi&#7875;u 3 k&#253; t&#7921;).</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold">M&#7853;t kh&#7849;u <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-key"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Nh&#7853;p m&#7853;t kh&#7849;u" required minlength="3">
                                <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p m&#7853;t kh&#7849;u (t&#7889;i thi&#7875;u 3 k&#253; t&#7921;).</div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="remember" name="remember">
                                <label class="form-check-label text-muted small" for="remember">Ghi nh&#7899; &#273;&#259;ng nh&#7853;p</label>
                            </div>
                            <a href="<c:url value='/forgot-password'/>" class="text-primary text-decoration-none small fw-semibold">
                                Qu&#234;n m&#7853;t kh&#7849;u?
                            </a>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-box-arrow-in-right me-1"></i>&#272;&#259;ng Nh&#7853;p
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-2 border-top">
                        <span class="text-muted small">Ch&#432;a c&#243; t&#224;i kho&#7843;n?</span>
                        <a href="<c:url value='/register'/>" class="text-primary text-decoration-none small fw-semibold ms-1">
                            &#272;&#259;ng k&#253; ngay
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/footer.jsp"/>
