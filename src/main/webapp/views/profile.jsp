<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="H&#7891; S&#417; Ng&#432;&#7901;i D&#249;ng - HCMUTE JPA" scope="request"/>
<jsp:include page="/views/layout/header.jsp"/>

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-9">

            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<c:url value='/home'/>" class="text-decoration-none">Trang Ch&#7911;</a></li>
                    <li class="breadcrumb-item active" aria-current="page">H&#7891; S&#417; Ng&#432;&#7901;i D&#249;ng</li>
                </ol>
            </nav>

            <c:if test="${not empty alert}">
                <div class="alert alert-danger d-flex align-items-center mb-4 shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 flex-shrink-0 fs-5"></i>
                    <div>${alert}</div>
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success d-flex align-items-center mb-4 shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2 flex-shrink-0 fs-5"></i>
                    <div>${message}</div>
                </div>
            </c:if>

            <div class="card shadow border-0 rounded-3">
                <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold text-dark">
                        <i class="bi bi-person-gear me-2 text-primary"></i>Th&#244;ng Tin T&#224;i Kho&#7843;n &amp; H&#7891; S&#417;
                    </h5>
                    <span class="badge ${user.roleid == 1 ? 'bg-danger' : (user.roleid == 2 ? 'bg-warning text-dark' : 'bg-primary')} px-3 py-2 rounded-pill">
                        <c:choose>
                            <c:when test="${user.roleid == 1}">Qu&#7843;n Tr&#7883; Vi&#234;n (Admin)</c:when>
                            <c:when test="${user.roleid == 2}">Qu&#7843;n L&#253; (Manager)</c:when>
                            <c:otherwise>Ng&#432;&#7901;i D&#249;ng (User)</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="card-body p-4 p-md-5">
                    <form action="<c:url value='/profile/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        <div class="row g-4 align-items-center mb-4 pb-4 border-bottom">
                            <div class="col-12 col-md-4 text-center">
                                <div class="position-relative d-inline-block mb-3">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar && user.avatar.startsWith('http')}">
                                            <img src="${user.avatar}" id="avatarPreview" alt="Avatar"
                                                 class="rounded-circle shadow border border-3 border-white"
                                                 style="width: 140px; height: 140px; object-fit: cover;">
                                        </c:when>
                                        <c:when test="${not empty user.avatar}">
                                            <img src="<c:url value='/image?fname=${user.avatar}'/>" id="avatarPreview" alt="Avatar"
                                                 class="rounded-circle shadow border border-3 border-white"
                                                 style="width: 140px; height: 140px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200" id="avatarPreview" alt="Avatar"
                                                 class="rounded-circle shadow border border-3 border-white"
                                                 style="width: 140px; height: 140px; object-fit: cover;">
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty user.avatar && user.avatar.contains('cloudinary')}">
                                        <div class="mt-2">
                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-2 py-1 small">
                                                <i class="bi bi-cloud-check-fill me-1"></i>Cloudinary CDN
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                                <div>
                                    <label for="avatarFile" class="btn btn-outline-primary btn-sm px-3">
                                        <i class="bi bi-camera me-1"></i>Ch&#7885;n &#7843;nh m&#7899;i (Multipart)
                                    </label>
                                    <input type="file" id="avatarFile" name="avatarFile" accept="image/*" class="d-none" onchange="previewAvatar(this);">
                                    <div class="form-text small mt-1">T&#7921; &#273;&#7897;ng t&#7843;i l&#234;n Cloudinary Cloud Storage</div>
                                </div>
                            </div>

                            <div class="col-12 col-md-8">
                                <h4 class="fw-bold mb-1">${user.fullName != null && !empty user.fullName ? user.fullName : user.userName}</h4>
                                <p class="text-muted mb-2">@${user.userName}</p>
                                <div class="d-flex flex-wrap gap-2 text-secondary small">
                                    <span><i class="bi bi-shield-check text-success me-1"></i>Tr&#7841;ng th&#225;i: <b>&#272;&#227; k&#237;ch ho&#7841;t OTP</b></span>
                                    <span>&bull;</span>
                                    <span><i class="bi bi-calendar3 me-1"></i>Ng&#224;y tham gia: <b>${user.createdDate != null ? user.createdDate : 'G&#7847;n &#273;&#226;y'}</b></span>
                                </div>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label fw-semibold">T&#234;n &#273;&#259;ng nh&#7853;p (Username)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-person-lock"></i></span>
                                    <input type="text" class="form-control bg-light" id="username" value="${user.userName}" readonly>
                                </div>
                                <div class="form-text small">T&#234;n &#273;&#259;ng nh&#7853;p c&#7889; &#273;&#7883;nh v&#224; kh&#244;ng th&#7875; thay &#273;&#7893;i.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="fullname" class="form-label fw-semibold">H&#7885; v&#224; t&#234;n <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                    <input type="text" class="form-control" id="fullname" name="fullname"
                                           value="${user.fullName}" placeholder="Nh&#7853;p h&#7885; v&#224; t&#234;n &#273;&#7847;y &#273;&#7911;"
                                           required minlength="2" maxlength="100">
                                    <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p h&#7885; v&#224; t&#234;n (t&#7889;i thi&#7875;u 2 k&#253; t&#7921;).</div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-semibold">S&#7889; &#273;i&#7879;n tho&#7841;i</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="${user.phone}" placeholder="0901234567"
                                           pattern="^(0[3|5|7|8|9])[0-9]{8}$">
                                    <div class="invalid-feedback">S&#7889; &#273;i&#7879;n tho&#7841;i Vi&#7879;t Nam g&#7891;m 10 ch&#7919; s&#7889; (03, 05, 07, 08, 09).</div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">&#272;&#7883;a ch&#7881; Email <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${user.email}" placeholder="example@gmail.com"
                                           required pattern="^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$">
                                    <div class="invalid-feedback">Vui l&#242;ng nh&#7853;p &#273;&#7883;a ch&#7881; email h&#7907;p l&#7879;.</div>
                                </div>
                                <div class="form-text text-warning">
                                    <i class="bi bi-info-circle me-1"></i>N&#7871;u b&#7841;n nh&#7853;p Email m&#7899;i, h&#7879; th&#7889;ng s&#7869; g&#7917;i m&#227; OTP &#273;&#7871;n email m&#7899;i &#273;&#7875; x&#225;c nh&#7853;n ho&#224;n t&#7845;t.
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                            <a href="<c:url value='/home'/>" class="btn btn-outline-secondary px-4">Quay L&#7841;i</a>
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="bi bi-floppy me-1"></i>L&#432;u Thay &#272;&#7893;i H&#7891; S&#417;
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function previewAvatar(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('avatarPreview').src = e.target.result;
        }
        reader.readAsDataURL(input.files[0]);
    }
}
</script>

<jsp:include page="/views/layout/footer.jsp"/>
