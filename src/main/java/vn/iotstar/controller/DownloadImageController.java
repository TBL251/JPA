package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.util.Constant;

/**
 * Controller phục vụ hiển thị ảnh và stream video tải lên (/image?fname=...)
 * Hỗ trợ HTTP Range (206 Partial Content) để phát và tua video HTML5 mượt mà.
 */
@WebServlet(urlPatterns = { "/image" })
public class DownloadImageController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int BUFFER_SIZE = 16 * 1024;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Chặn path traversal (../ hoặc đường dẫn tuyệt đối)
        fileName = new File(fileName.trim()).getName();
        File file = new File(Constant.getUploadDir(), fileName);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String lower = fileName.toLowerCase();
        String contentType;
        if (lower.endsWith(".mp4")) {
            contentType = "video/mp4";
        } else if (lower.endsWith(".webm")) {
            contentType = "video/webm";
        } else if (lower.endsWith(".ogg") || lower.endsWith(".ogv")) {
            contentType = "video/ogg";
        } else if (lower.endsWith(".mov")) {
            contentType = "video/quicktime";
        } else if (lower.endsWith(".png")) {
            contentType = "image/png";
        } else if (lower.endsWith(".gif")) {
            contentType = "image/gif";
        } else if (lower.endsWith(".webp")) {
            contentType = "image/webp";
        } else {
            contentType = "image/jpeg";
        }

        long fileLength = file.length();
        long start = 0;
        long end = fileLength - 1;

        String range = req.getHeader("Range");
        boolean isPartial = false;
        if (range != null && range.startsWith("bytes=")) {
            String[] parts = range.substring(6).split("-", 2);
            try {
                if (!parts[0].isEmpty()) {
                    start = Long.parseLong(parts[0]);
                }
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    end = Long.parseLong(parts[1]);
                }
                if (start > end || start >= fileLength) {
                    resp.setHeader("Content-Range", "bytes */" + fileLength);
                    resp.sendError(HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                    return;
                }
                if (end >= fileLength) {
                    end = fileLength - 1;
                }
                isPartial = true;
            } catch (NumberFormatException ignored) {
                start = 0;
                end = fileLength - 1;
            }
        }

        long contentLength = end - start + 1;
        resp.setContentType(contentType);
        resp.setHeader("Accept-Ranges", "bytes");
        resp.setHeader("Content-Length", String.valueOf(contentLength));
        if (isPartial) {
            resp.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            resp.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + fileLength);
        }

        try (RandomAccessFile raf = new RandomAccessFile(file, "r");
             OutputStream out = resp.getOutputStream()) {
            raf.seek(start);
            byte[] buffer = new byte[BUFFER_SIZE];
            long remaining = contentLength;
            while (remaining > 0) {
                int read = raf.read(buffer, 0, (int) Math.min(buffer.length, remaining));
                if (read == -1) {
                    break;
                }
                out.write(buffer, 0, read);
                remaining -= read;
            }
        } catch (IOException ignored) {
            // Trình duyệt ngắt kết nối khi tua/đóng video là hành vi bình thường
        }
    }
}
