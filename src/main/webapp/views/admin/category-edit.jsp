<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="C&#7853;p Nh&#7853;t Danh M&#7909;c - Admin" scope="request"/>
<jsp:include page="/views/layout/admin-header.jsp"/>

<div class="row justify-content-center">
    <div class="col-12 col-lg-8">
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold text-primary">
                    <i class="bi bi-pencil-square me-2"></i>C&#7853;p Nh&#7853;t Danh M&#7909;c #${cate.categoryId}
                </h5>
                <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i>Quay l&#7841;i danh s&#225;ch
                </a>
            </div>

            <div class="card-body p-4">
                <c:if test="${not empty alert}">
                    <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 flex-shrink-0"></i>
                        <div>${alert}</div>
                    </div>
                </c:if>

                <form action="<c:url value='/admin/category/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <input type="hidden" name="categoryid" value="${cate.categoryId}">

                    <div class="mb-3">
                        <label for="categoryname" class="form-label fw-semibold">T&#234;n Danh M&#7909;c <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="categoryname" name="categoryname"
                               value="${cate.categoryname}" placeholder="V&#237; d&#7909;: &#272;i&#7879;n tho&#7841;i, Laptop, Th&#7901;i trang..."
                               required minlength="2" maxlength="100">
                        <div class="invalid-feedback">T&#234;n danh m&#7909;c kh&#244;ng &#273;&#432;&#7907;c &#273;&#7875; tr&#7889;ng v&#224; ph&#7843;i c&#243; &#273;&#7897; d&#224;i t&#7915; 2 &#273;&#7871;n 100 k&#253; t&#7921;.</div>
                    </div>

                    <div class="mb-3">
                        <label for="images" class="form-label fw-semibold">Link H&#236;nh &#7842;nh (URL tr&#7921;c ti&#7871;p n&#7871;u c&#243;)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
                            <input type="url" class="form-control" id="images" name="images"
                                   value="${cate.images}" placeholder="https://example.com/image.jpg">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold d-block">&#7842;nh hi&#7879;n t&#7841;i:</label>
                        <c:choose>
                            <c:when test="${cate.images != null && cate.images.startsWith('http')}">
                                <img src="${cate.images}" alt="${cate.categoryname}" class="rounded border p-1" style="width: 140px; height: 100px; object-fit: cover;">
                            </c:when>
                            <c:when test="${cate.images != null && !empty cate.images}">
                                <img src="<c:url value='/image?fname=${cate.images}'/>" alt="${cate.categoryname}" class="rounded border p-1" style="width: 140px; height: 100px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted small fst-italic">Ch&#432;a c&#243; &#7843;nh</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-3">
                        <label for="images1" class="form-label fw-semibold">T&#7843;i &#7843;nh m&#7899;i thay th&#7871; (t&#249;y ch&#7885;n)</label>
                        <input type="file" class="form-control" id="images1" name="images1" accept="image/*">
                        <div class="form-text">H&#7895; tr&#7907; c&#225;c &#273;&#7883;nh d&#7841;ng: .jpg, .jpeg, .png, .webp, .gif.</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold d-block">Tr&#7841;ng th&#225;i (Status)</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status" id="statusActive" value="1" ${cate.status == 1 ? 'checked' : ''}>
                            <label class="form-check-label text-success fw-semibold" for="statusActive">
                                <i class="bi bi-check-circle me-1"></i>Ho&#7841;t &#273;&#7897;ng
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status" id="statusInactive" value="0" ${cate.status == 0 ? 'checked' : ''}>
                            <label class="form-check-label text-secondary fw-semibold" for="statusInactive">
                                <i class="bi bi-x-circle me-1"></i>T&#7841;m kh&#243;a
                            </label>
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-end pt-3 border-top">
                        <a href="<c:url value='/admin/categories'/>" class="btn btn-secondary px-4">H&#7911;y b&#7887;</a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            <i class="bi bi-check-lg me-1"></i>C&#7853;p Nh&#7853;t Danh M&#7909;c
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/admin-footer.jsp"/>
