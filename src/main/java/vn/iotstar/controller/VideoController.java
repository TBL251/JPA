package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.UserService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

/**
 * Controller Quản trị Video (CRUD Videos) với hỗ trợ Upload Multipart theo chuẩn Jakarta EE
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 100, // 100MB (hỗ trợ upload file video MP4/WebM)
        maxRequestSize = 1024 * 1024 * 120) // 120MB
@WebServlet(urlPatterns = { "/admin/videos", "/admin/video/list", "/admin/video/add", "/admin/video/insert",
        "/admin/video/edit", "/admin/video/update", "/admin/video/delete" })
public class VideoController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final IVideoService videoService = new VideoServiceImpl();
    private final ICategoryService cateService = new CategoryServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();

        if (url.contains("/admin/videos") || url.contains("/admin/video/list")) {
            List<Video> list = videoService.findAll();
            req.setAttribute("listvideo", list);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/add")) {
            List<Category> listcate = cateService.findAll();
            req.setAttribute("listcate", listcate);
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/edit")) {
            String id = req.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                Video video = videoService.findById(id.trim());
                req.setAttribute("video", video);
            }
            List<Category> listcate = cateService.findAll();
            req.setAttribute("listcate", listcate);
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/delete")) {
            String id = req.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                try {
                    videoService.delete(id.trim());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();

        if (url.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            boolean active = "1".equals(activeStr) || "true".equalsIgnoreCase(activeStr);
            String categoryIdStr = req.getParameter("categoryId");
            String posterUrl = req.getParameter("poster");
            String videoUrlInput = req.getParameter("videoUrl");

            // Server-side Validation
            if (videoId == null || videoId.trim().length() < 2 || title == null || title.trim().length() < 3 || categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập đầy đủ Mã Video (>= 2 ký tự), Tiêu đề (>= 3 ký tự) và chọn Danh mục liên kết!");
                req.setAttribute("videoId", videoId);
                req.setAttribute("title", title);
                req.setAttribute("description", description);
                req.setAttribute("categoryId", categoryIdStr);
                req.setAttribute("poster", posterUrl);
                req.setAttribute("videoUrl", videoUrlInput);
                req.setAttribute("listcate", cateService.findAll());
                req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                return;
            }

            Video video = new Video();
            video.setVideoId(videoId.trim());
            video.setTitle(title.trim());
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);

            // Gán Category
            try {
                int catId = Integer.parseInt(categoryIdStr.trim());
                Category cat = cateService.findById(catId);
                video.setCategory(cat);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Gán User sở hữu video
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("account") : null;
            if (currentUser == null) {
                currentUser = userService.get("admin");
            }
            video.setUser(currentUser);

            // Xử lý upload file poster qua Multipart
            String posterName = handleFileUpload(req, "posterFile", "poster_");
            if (posterName != null && !posterName.isEmpty()) {
                video.setPoster(posterName);
            } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                video.setPoster(posterUrl.trim());
            } else {
                video.setPoster("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600");
            }

            // Xử lý upload file video qua Multipart hoặc URL video
            String uploadedVideo = handleFileUpload(req, "videoFile", "video_");
            if (uploadedVideo != null && !uploadedVideo.isEmpty()) {
                video.setVideoUrl(uploadedVideo);
            } else if (videoUrlInput != null && !videoUrlInput.trim().isEmpty()) {
                video.setVideoUrl(videoUrlInput.trim());
            }

            try {
                videoService.insert(video);
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("alert", "Không thể lưu video (có thể Mã Video đã tồn tại): " + e.getMessage());
                req.setAttribute("videoId", videoId);
                req.setAttribute("title", title);
                req.setAttribute("description", description);
                req.setAttribute("categoryId", categoryIdStr);
                req.setAttribute("poster", posterUrl);
                req.setAttribute("videoUrl", videoUrlInput);
                req.setAttribute("listcate", cateService.findAll());
                req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (url.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            boolean active = "1".equals(activeStr) || "true".equalsIgnoreCase(activeStr);
            String categoryIdStr = req.getParameter("categoryId");
            String posterUrl = req.getParameter("poster");
            String videoUrlInput = req.getParameter("videoUrl");

            Video video = videoService.findById(videoId != null ? videoId.trim() : "");
            if (video == null) {
                video = new Video();
                video.setVideoId(videoId);
            }

            // Server-side Validation
            if (title == null || title.trim().length() < 3 || categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập đầy đủ Tiêu đề Video (>= 3 ký tự) và chọn Danh mục liên kết!");
                video.setTitle(title);
                video.setDescription(description);
                req.setAttribute("video", video);
                req.setAttribute("listcate", cateService.findAll());
                req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
                return;
            }

            video.setTitle(title.trim());
            video.setDescription(description);
            video.setActive(active);

            // Gán Category
            try {
                int catId = Integer.parseInt(categoryIdStr.trim());
                Category cat = cateService.findById(catId);
                video.setCategory(cat);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Xử lý upload file poster mới nếu có
            String posterName = handleFileUpload(req, "posterFile", "poster_");
            if (posterName != null && !posterName.isEmpty()) {
                video.setPoster(posterName);
            } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                video.setPoster(posterUrl.trim());
            }

            // Xử lý upload file video mới nếu có hoặc cập nhật URL video
            String uploadedVideo = handleFileUpload(req, "videoFile", "video_");
            if (uploadedVideo != null && !uploadedVideo.isEmpty()) {
                video.setVideoUrl(uploadedVideo);
            } else if (videoUrlInput != null && !videoUrlInput.trim().isEmpty()) {
                video.setVideoUrl(videoUrlInput.trim());
            }

            try {
                videoService.update(video);
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("alert", "Không thể cập nhật video: " + e.getMessage());
                req.setAttribute("video", video);
                req.setAttribute("listcate", cateService.findAll());
                req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    private String handleFileUpload(HttpServletRequest req, String partName, String prefix) {
        try {
            Part part = req.getPart(partName);
            if (part != null && part.getSize() > 0) {
                String uploadPath = Constant.getUploadDir();
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String submittedFileName = part.getSubmittedFileName();
                String defaultName = "video_".equals(prefix) ? "video.mp4" : "poster.jpg";
                String filename = Paths.get(submittedFileName != null && !submittedFileName.isEmpty() ? submittedFileName : defaultName)
                        .getFileName().toString();
                int dotIndex = filename.lastIndexOf(".");
                String ext = (dotIndex > 0) ? filename.substring(dotIndex).toLowerCase() : ("video_".equals(prefix) ? ".mp4" : ".jpg");
                String newFileName = prefix + System.currentTimeMillis() + ext;

                part.write(uploadPath + File.separator + newFileName);
                return newFileName;
            }
        } catch (Exception e) {
            System.err.println("[MULTIPART UPLOAD ERROR] " + e.getMessage());
        }
        return null;
    }
}
