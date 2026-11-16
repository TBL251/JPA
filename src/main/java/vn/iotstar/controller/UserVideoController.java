package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

/**
 * Controller hiển thị tất cả videos của user với phân trang 6sp/trang
 * URL: /video?page=1
 */
@WebServlet(urlPatterns = { "/video" })
public class UserVideoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int PAGE_SIZE = 6; // 6 video / trang theo yêu cầu đề bài
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("account") : null;

        List<Video> videos;
        int totalVideos;

        if (currentUser != null) {
            // Lấy danh sách video thuộc quyền sở hữu của user đang đăng nhập
            totalVideos = videoService.countByUserId(currentUser.getId());
            videos = videoService.findByUserId(currentUser.getId(), page, PAGE_SIZE);

            // Nếu user chưa đăng video nào (hoặc dữ liệu demo chưa gán userId), hỗ trợ fallback hiển thị video hệ thống
            if (totalVideos == 0) {
                totalVideos = videoService.count();
                videos = videoService.findAll(page, PAGE_SIZE);
                req.setAttribute("infoMsg", "Bạn chưa tải lên video nào. Đang hiển thị danh sách video gợi ý của hệ thống:");
            }
        } else {
            // Nếu chưa đăng nhập, hiển thị tất cả video công khai và gợi ý đăng nhập
            totalVideos = videoService.count();
            videos = videoService.findAll(page, PAGE_SIZE);
            req.setAttribute("infoMsg", "Đăng nhập để xem và quản lý bộ sưu tập video cá nhân của bạn.");
        }

        int totalPages = (int) Math.ceil((double) totalVideos / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("videos", videos);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);

        req.getRequestDispatcher("/views/video-list.jsp").forward(req, resp);
    }
}
