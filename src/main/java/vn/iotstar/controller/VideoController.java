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
        maxFileSize = 1024 * 1024 * 50, // 50MB (hỗ trợ cả video ngắn / poster chất lượng cao)
        maxRequestSize = 1024 * 1024 * 100) // 100MB
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

            Video video = new Video();
            video.setVideoId(videoId != null ? videoId.trim() : "v" + System.currentTimeMillis());
            video.setTitle(title);
            video.setDescription(description);
            video.setActive(active);
            video.setViews(0);

            // Gán Category
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int catId = Integer.parseInt(categoryIdStr.trim());
                    Category cat = cateService.findById(catId);
                    video.setCategory(cat);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // Gán User sở hữu video
            HttpSession session = req.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("account") : null;
            if (currentUser == null) {
                currentUser = userService.get("admin");
            }
            video.setUser(currentUser);

            // Xử lý upload file poster qua Multipart
            String posterName = handleFileUpload(req, "posterFile");
            if (posterName != null && !posterName.isEmpty()) {
                video.setPoster(posterName);
            } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                video.setPoster(posterUrl.trim());
            } else {
                video.setPoster("https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600");
            }

            try {
                videoService.insert(video);
            } catch (Exception e) {
                e.printStackTrace();
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

            Video video = videoService.findById(videoId != null ? videoId.trim() : "");
            if (video == null) {
                video = new Video();
                video.setVideoId(videoId);
            }

            video.setTitle(title);
            video.setDescription(description);
            video.setActive(active);

            // Gán Category
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int catId = Integer.parseInt(categoryIdStr.trim());
                    Category cat = cateService.findById(catId);
                    video.setCategory(cat);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // Xử lý upload file poster mới nếu có
            String posterName = handleFileUpload(req, "posterFile");
            if (posterName != null && !posterName.isEmpty()) {
                video.setPoster(posterName);
            } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                video.setPoster(posterUrl.trim());
            }

            try {
                videoService.update(video);
            } catch (Exception e) {
                e.printStackTrace();
            }

            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    private String handleFileUpload(HttpServletRequest req, String partName) {
        try {
            Part part = req.getPart(partName);
            if (part != null && part.getSize() > 0) {
                String uploadPath = Constant.getUploadDir();
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String submittedFileName = part.getSubmittedFileName();
                String filename = Paths.get(submittedFileName != null ? submittedFileName : "poster.jpg")
                        .getFileName().toString();
                int dotIndex = filename.lastIndexOf(".");
                String ext = (dotIndex > 0) ? filename.substring(dotIndex) : ".jpg";
                String newFileName = System.currentTimeMillis() + ext;

                part.write(uploadPath + File.separator + newFileName);
                return newFileName;
            }
        } catch (Exception e) {
            System.err.println("[MULTIPART UPLOAD ERROR] " + e.getMessage());
        }
        return null;
    }
}
