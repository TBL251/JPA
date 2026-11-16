package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;

@WebServlet(urlPatterns = { "/home" })
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ICategoryService cateService = new CategoryServiceImpl();
    private final IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy danh sách danh mục (categories)
        List<Category> listCate = cateService.findAll();
        req.setAttribute("listcate", listCate);

        // 2. Lấy 10 video mới nhất hiển thị lên trang chủ theo yêu cầu đề bài
        List<Video> topVideos = videoService.findTop10Latest();
        req.setAttribute("topVideos", topVideos);

        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
