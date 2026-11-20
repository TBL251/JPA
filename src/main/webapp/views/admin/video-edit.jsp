<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="C&#7853;p Nh&#7853;t Video - Admin" scope="request"/>
<jsp:include page="/views/layout/admin-header.jsp"/>

<div class="row justify-content-center">
    <div class="col-12 col-lg-8">
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold text-primary">
                    <i class="bi bi-pencil-square me-2"></i>C&#7853;p Nh&#7853;t Video: ${video.videoId}
                </h5>
                <a href="<c:url value='/admin/videos'/>" class="btn btn-outline-secondary btn-sm">
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

                <form action="<c:url value='/admin/video/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="videoId" class="form-label fw-semibold">M&#227; Video (ID)</label>
                        <input type="text" class="form-control bg-light" id="videoId" name="videoId"
                               value="${video.videoId}" readonly>
                        <div class="form-text">M&#227; &#273;&#7883;nh danh video l&#224; duy nh&#7845;t v&#224; kh&#244;ng th&#7875; thay &#273;&#7893;i.</div>
                    </div>

                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold">Ti&#234;u &#272;&#7873; Video <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${video.title}" placeholder="Nh&#7853;p ti&#234;u &#273;&#7873; video"
                               required minlength="3" maxlength="255">
                        <div class="invalid-feedback">Ti&#234;u &#273;&#7873; video kh&#244;ng &#273;&#432;&#7907;c &#273;&#7875; tr&#7889;ng (t&#7889;i thi&#7875;u 3 k&#253; t&#7921;).</div>
                    </div>

                    <div class="mb-3">
                        <label for="categoryId" class="form-label fw-semibold">Danh M&#7909;c (Category) <span class="text-danger">*</span></label>
                        <select class="form-select" id="categoryId" name="categoryId" required>
                            <option value="">-- Ch&#7885;n danh m&#7909;c li&#234;n k&#7871;t --</option>
                            <c:forEach items="${listcate}" var="c">
                                <option value="${c.categoryId}" ${video.category != null && video.category.categoryId == c.categoryId ? 'selected' : ''}>
                                    ${c.categoryname}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Vui l&#242;ng ch&#7885;n danh m&#7909;c cho video.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold d-block">Poster hi&#7879;n t&#7841;i:</label>
                        <c:choose>
                            <c:when test="${video.poster != null && video.poster.startsWith('http')}">
                                <img src="${video.poster}" alt="${video.title}" class="rounded border p-1" style="width: 160px; height: 100px; object-fit: cover;">
                            </c:when>
                            <c:when test="${video.poster != null && !empty video.poster}">
                                <img src="<c:url value='/image?fname=${video.poster}'/>" alt="${video.title}" class="rounded border p-1" style="width: 160px; height: 100px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted small fst-italic">Ch&#432;a c&#243; poster</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="mb-3">
                        <label for="videoFile" class="form-label fw-semibold">T&#7843;i l&#234;n file Video m&#7899;i thay th&#7871; (t&#249;y ch&#7885;n)</label>
                        <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/webm,video/ogg,video/*">
                        <div class="form-text">
                            <c:choose>
                                <c:when test="${not empty video.videoUrl}">Ngu&#7891;n hi&#7879;n t&#7841;i: <code>${video.videoUrl}</code></c:when>
                                <c:otherwise>Ch&#432;a c&#243; file/link video ri&#234;ng (&#273;ang d&#249;ng video m&#7851;u).</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="videoUrl" class="form-label fw-semibold">Ho&#7863;c li&#234;n k&#7871;t Video tr&#7921;c tuy&#7871;n (URL MP4 / YouTube)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-camera-video"></i></span>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl"
                                   value="${video.videoUrl}" placeholder="https://www.youtube.com/watch?v=... ho&#7863;c link .mp4">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="posterFile" class="form-label fw-semibold">T&#7843;i l&#234;n Poster m&#7899;i thay th&#7871; (t&#249;y ch&#7885;n)</label>
                        <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                        <div class="form-text">H&#7895; tr&#7907; c&#225;c &#273;&#7883;nh d&#7841;ng: .jpg, .jpeg, .png, .webp.</div>
                    </div>

                    <div class="mb-3">
                        <label for="poster" class="form-label fw-semibold">Ho&#7863;c li&#234;n k&#7871;t Poster tr&#7921;c tuy&#7871;n (URL)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
                            <input type="text" class="form-control" id="poster" name="poster"
                                   value="${video.poster}" placeholder="https://images.unsplash.com/...">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-semibold">M&#244; T&#7843; Chi Ti&#7871;t</label>
                        <textarea class="form-control" id="description" name="description" rows="3">${video.description}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold d-block">Tr&#7841;ng Th&#225;i Hi&#7875;n Th&#7883;</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="activeOn" value="1" ${video.active ? 'checked' : ''}>
                            <label class="form-check-label text-success fw-semibold" for="activeOn">
                                <i class="bi bi-eye me-1"></i>C&#244;ng khai (Hi&#7875;n th&#7883;)
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="activeOff" value="0" ${!video.active ? 'checked' : ''}>
                            <label class="form-check-label text-secondary fw-semibold" for="activeOff">
                                <i class="bi bi-eye-slash me-1"></i>&#7848;n video
                            </label>
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-end pt-3 border-top">
                        <a href="<c:url value='/admin/videos'/>" class="btn btn-secondary px-4">H&#7911;y b&#7887;</a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            <i class="bi bi-check-lg me-1"></i>C&#7853;p Nh&#7853;t Video
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/admin-footer.jsp"/>
