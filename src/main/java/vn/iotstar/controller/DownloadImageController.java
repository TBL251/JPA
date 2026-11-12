package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.apache.commons.io.IOUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.util.Constant;

/**
 * Controller phục vụ hiển thị ảnh tải lên (/image?fname=...)
 */
@WebServlet(urlPatterns = { "/image" })
public class DownloadImageController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            return;
        }

        File file = new File(Constant.getUploadDir() + File.separator + fileName);

        if (fileName.toLowerCase().endsWith(".png")) {
            resp.setContentType("image/png");
        } else if (fileName.toLowerCase().endsWith(".gif")) {
            resp.setContentType("image/gif");
        } else {
            resp.setContentType("image/jpeg");
        }

        if (file.exists()) {
            try (FileInputStream in = new FileInputStream(file)) {
                IOUtils.copy(in, resp.getOutputStream());
            }
        }
    }
}

