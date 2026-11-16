package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

/**
 * Controller xem chi tiết và phát (play) 01 video khi click vào tiêu đề từ /home hoặc /video
 * URL: /video/detail?id=v01
 */
@WebServlet(urlPatterns = { "/video/detail" })
public class VideoDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoId = req.getParameter("id");

        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // 1. Tự động tăng lượt xem
        videoService.increaseViews(videoId.trim());

        // 2. Lấy thông tin chi tiết video
        Video video = videoService.findById(videoId.trim());

        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // 3. Lấy danh sách video đề xuất liên quan (top video mới nhất)
        List<Video> relatedVideos = videoService.findTop10Latest();

        req.setAttribute("video", video);
        req.setAttribute("relatedVideos", relatedVideos);

        req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
    }
}
