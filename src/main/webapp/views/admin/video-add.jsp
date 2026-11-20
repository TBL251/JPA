<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Th&#234;m Video M&#7899;i - Admin" scope="request"/>
<jsp:include page="/views/layout/admin-header.jsp"/>

<div class="row justify-content-center">
    <div class="col-12 col-lg-8">
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold text-primary">
                    <i class="bi bi-film me-2"></i>Th&#234;m Video M&#7899;i (Multipart &amp; JPA)
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

                <form action="<c:url value='/admin/video/insert'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="videoId" class="form-label fw-semibold">M&#227; Video (ID) <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="videoId" name="videoId"
                               value="${videoId}" placeholder="V&#237; d&#7909;: vid_123, v01..."
                               required minlength="2" maxlength="50" pattern="^[a-zA-Z0-9_\-]+$">
                        <div class="invalid-feedback">M&#227; Video kh&#244;ng &#273;&#432;&#7907;c &#273;&#7875; tr&#7889;ng (2-50 k&#253; t&#7921;, ch&#7881; g&#7891;m ch&#7919; c&#225;i, s&#7889;, g&#7841;ch ngang ho&#7863;c g&#7841;ch d&#432;&#7899;i).</div>
                    </div>

                    <div class="mb-3">
                        <label for="title" class="form-label fw-semibold">Ti&#234;u &#272;&#7873; Video <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="title" name="title"
                               value="${title}" placeholder="Nh&#7853;p ti&#234;u &#273;&#7873; video"
                               required minlength="3" maxlength="255">
                        <div class="invalid-feedback">Ti&#234;u &#273;&#7873; video kh&#244;ng &#273;&#432;&#7907;c &#273;&#7875; tr&#7889;ng (t&#7889;i thi&#7875;u 3 k&#253; t&#7921;).</div>
                    </div>

                    <div class="mb-3">
                        <label for="categoryId" class="form-label fw-semibold">Danh M&#7909;c (Category) <span class="text-danger">*</span></label>
                        <select class="form-select" id="categoryId" name="categoryId" required>
                            <option value="">-- Ch&#7885;n danh m&#7909;c li&#234;n k&#7871;t --</option>
                            <c:forEach items="${listcate}" var="c">
                                <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>${c.categoryname}</option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">Vui l&#242;ng ch&#7885;n danh m&#7909;c cho video.</div>
                    </div>

                    <div class="mb-3">
                        <label for="videoFile" class="form-label fw-semibold">T&#7843;i l&#234;n file Video (Multipart - MP4, WebM, OGG)</label>
                        <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/mp4,video/webm,video/ogg,video/*">
                        <div class="form-text">H&#7895; tr&#7907; file .mp4, .webm, .ogg, .mov (t&#7889;i &#273;a 100MB).</div>
                    </div>

                    <div class="mb-3">
                        <label for="videoUrl" class="form-label fw-semibold">Ho&#7863;c li&#234;n k&#7871;t Video tr&#7921;c tuy&#7871;n (URL MP4 / YouTube)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-camera-video"></i></span>
                            <input type="text" class="form-control" id="videoUrl" name="videoUrl"
                                   value="${videoUrl}" placeholder="https://www.youtube.com/watch?v=... ho&#7863;c link .mp4">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="posterFile" class="form-label fw-semibold">T&#7843;i l&#234;n file &#7843;nh Poster (Multipart)</label>
                        <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                        <div class="form-text">H&#7895; tr&#7907; c&#225;c &#273;&#7883;nh d&#7841;ng: .jpg, .jpeg, .png, .webp.</div>
                    </div>

                    <div class="mb-3">
                        <label for="poster" class="form-label fw-semibold">Ho&#7863;c li&#234;n k&#7871;t Poster (URL Tr&#7921;c Tuy&#7871;n)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
                            <input type="text" class="form-control" id="poster" name="poster"
                                   value="${poster}" placeholder="https://images.unsplash.com/...">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-semibold">M&#244; T&#7843; Chi Ti&#7871;t</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  placeholder="M&#244; t&#7843; n&#7897;i dung video...">${description}</textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold d-block">Tr&#7841;ng Th&#225;i Hi&#7875;n Th&#7883;</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="activeOn" value="1" checked>
                            <label class="form-check-label text-success fw-semibold" for="activeOn">
                                <i class="bi bi-eye me-1"></i>C&#244;ng khai (Hi&#7875;n th&#7883;)
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="active" id="activeOff" value="0">
                            <label class="form-check-label text-secondary fw-semibold" for="activeOff">
                                <i class="bi bi-eye-slash me-1"></i>&#7848;n video
                            </label>
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-end pt-3 border-top">
                        <a href="<c:url value='/admin/videos'/>" class="btn btn-secondary px-4">H&#7911;y b&#7887;</a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold">
                            <i class="bi bi-cloud-upload me-1"></i>L&#432;u Video
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/views/layout/admin-footer.jsp"/>
