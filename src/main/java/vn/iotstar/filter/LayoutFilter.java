package vn.iotstar.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.*;

/**
 * Layout filter: buffers JSP output on FORWARD dispatch and injects Bootstrap template.
 * On REQUEST dispatch it passes through; on FORWARD it wraps and injects layout.
 * This is needed because Tomcat bypasses the REQUEST response wrapper when forwarding.
 */
@WebFilter(filterName = "layout", urlPatterns = "/*")
public class LayoutFilter implements Filter {

    private static final String LAYOUT_DONE = "vn.iotstar.layout.done";

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();

        // Skip non-HTML paths
        if (path != null && (path.startsWith("/image") || path.startsWith("/api")
                || path.endsWith(".css") || path.endsWith(".js")
                || path.endsWith(".png") || path.endsWith(".jpg")
                || path.endsWith(".ico") || path.endsWith(".woff")
                || path.endsWith(".woff2") || path.endsWith(".map"))) {
            chain.doFilter(req, res);
            return;
        }

        // If layout already applied in this request cycle, pass through
        if (Boolean.TRUE.equals(request.getAttribute(LAYOUT_DONE))) {
            chain.doFilter(req, res);
            return;
        }

        // Mark layout as applied before forwarding to prevent double-injection
        request.setAttribute(LAYOUT_DONE, Boolean.TRUE);

        // Buffer the response
        CharArrayWriter buffer = new CharArrayWriter();
        HttpServletResponse wrapper = new HttpServletResponseWrapper(response) {
            private PrintWriter pw;
            @Override public PrintWriter getWriter() throws IOException {
                if (pw == null) pw = new PrintWriter(buffer);
                return pw;
            }
            @Override public ServletOutputStream getOutputStream() throws IOException {
                return new ServletOutputStream() {
                    @Override public boolean isReady() { return true; }
                    @Override public void setWriteListener(WriteListener l) {}
                    @Override public void write(int b) { buffer.write(b); }
                    @Override public void write(byte[] b, int off, int len) {
                        for (int i = off; i < off + len; i++) buffer.write(b[i]);
                    }
                };
            }
            @Override public void flushBuffer() { /* suppress premature flush */ }
        };

        chain.doFilter(request, wrapper);

        String body = buffer.toString();

        if (body.isEmpty()) {
            // Chain did a sendRedirect or wrote nothing — nothing to inject
            return;
        }

        // Extract <title>…</title>
        String title = "HCMUTE JPA";
        int tStart = body.indexOf("<title>");
        int tEnd   = body.indexOf("</title>");
        if (tStart >= 0 && tEnd > tStart) {
            title = body.substring(tStart + 7, tEnd).trim();
        }

        // Extract everything inside <body>…</body>
        String content = body;
        int bStart = body.indexOf("<body>");
        int bEnd   = body.lastIndexOf("</body>");
        if (bStart >= 0 && bEnd > bStart) {
            content = body.substring(bStart + 6, bEnd);
        }

        // Extra <head> content (styles/scripts) added by JSP
        String extraHead = "";
        int hStart = body.indexOf("<head>");
        int hEnd   = body.indexOf("</head>");
        if (hStart >= 0 && hEnd > hStart) {
            String headBlock = body.substring(hStart + 6, hEnd);
            extraHead = headBlock.replaceAll("(?i)<title[^>]*>.*?</title>", "").trim();
        }

        boolean isAdmin = path != null && path.startsWith("/admin");
        String ctx = request.getContextPath();

        if (response.isCommitted()) return;
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        if (isAdmin) {
            out.print(adminTemplate(ctx, title, content, extraHead));
        } else {
            out.print(webTemplate(ctx, title, content, extraHead));
        }
        out.flush();
    }

    // ── Web (user-facing) template ───────────────────────────────────────────
    private String webTemplate(String ctx, String title, String content, String extraHead) {
        return "<!DOCTYPE html>\n" +
            "<html lang=\"vi\">\n" +
            "<head>\n" +
            "<meta charset=\"UTF-8\">\n" +
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
            "<title>" + title + "</title>\n" +
            "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n" +
            "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css\" rel=\"stylesheet\">\n" +
            "<style>\n" +
            "body{font-family:system-ui,-apple-system,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;" +
            "background:#f8fafc;color:#1e293b;min-height:100vh;display:flex;flex-direction:column}\n" +
            "main{flex:1 0 auto}\n" +
            "</style>\n" +
            extraHead + "\n" +
            "</head>\n" +
            "<body>\n" +
            "<nav class=\"navbar navbar-expand-lg navbar-dark py-2 shadow-sm\" style=\"background:#0f172a\">\n" +
            "  <div class=\"container-fluid px-lg-4\">\n" +
            "    <a class=\"navbar-brand fw-bold text-info\" href=\"" + ctx + "/home\">" +
            "<i class=\"bi bi-play-circle-fill fs-4 text-primary\"></i> HCMUTE JPA</a>\n" +
            "    <button class=\"navbar-toggler border-0\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#nav\">" +
            "<span class=\"navbar-toggler-icon\"></span></button>\n" +
            "    <div class=\"collapse navbar-collapse\" id=\"nav\">\n" +
            "      <ul class=\"navbar-nav me-auto\">\n" +
            "        <li class=\"nav-item\"><a class=\"nav-link text-light\" href=\"" + ctx + "/home\">Trang Ch&#7911;</a></li>\n" +
            "        <li class=\"nav-item\"><a class=\"nav-link text-light\" href=\"" + ctx + "/video\">Video</a></li>\n" +
            "      </ul>\n" +
            "      <ul class=\"navbar-nav ms-auto\">\n" +
            "        <li class=\"nav-item\"><a class=\"btn btn-outline-light btn-sm px-3 me-2\" href=\"" + ctx + "/login\">&#272;&#259;ng Nh&#7853;p</a></li>\n" +
            "        <li class=\"nav-item\"><a class=\"btn btn-primary btn-sm px-3\" href=\"" + ctx + "/register\">&#272;&#259;ng K&yacute;</a></li>\n" +
            "      </ul>\n" +
            "    </div>\n" +
            "  </div>\n" +
            "</nav>\n" +
            "<main class=\"container-fluid px-0 py-3\">" + content + "</main>\n" +
            "<footer class=\"bg-dark text-white-50 py-3 mt-auto text-center small\">\n" +
            "  <p class=\"mb-0\">&copy; 2026 HCMUTE - HCM University of Technology and Education</p>\n" +
            "</footer>\n" +
            "<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js\"></script>\n" +
            "<script>(() => {'use strict';const f=document.querySelectorAll('.needs-validation');" +
            "Array.from(f).forEach(form=>form.addEventListener('submit',e=>{" +
            "if(!form.checkValidity()){e.preventDefault();e.stopPropagation()}" +
            "form.classList.add('was-validated')},false))})()</script>\n" +
            "</body>\n</html>\n";
    }

    // ── Admin template ───────────────────────────────────────────────────────
    private String adminTemplate(String ctx, String title, String content, String extraHead) {
        return "<!DOCTYPE html>\n" +
            "<html lang=\"vi\">\n" +
            "<head>\n" +
            "<meta charset=\"UTF-8\">\n" +
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
            "<title>" + title + "</title>\n" +
            "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n" +
            "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css\" rel=\"stylesheet\">\n" +
            "<style>\n" +
            "#sidebar{width:240px;min-height:100vh;background:#0f172a;position:fixed;top:0;left:0;z-index:100}\n" +
            "#main-content{margin-left:240px;min-height:100vh;background:#f1f5f9}\n" +
            "@media(max-width:768px){#sidebar{position:relative;width:100%;min-height:auto}" +
            "#main-content{margin-left:0}}\n" +
            "</style>\n" +
            extraHead + "\n" +
            "</head>\n" +
            "<body>\n" +
            "<div id=\"sidebar\" class=\"d-flex flex-column p-3\">\n" +
            "  <a class=\"navbar-brand fw-bold text-info mb-4\" href=\"" + ctx + "/admin/categories\">" +
            "<i class=\"bi bi-grid-3x3-gap-fill me-2\"></i>Admin Panel</a>\n" +
            "  <ul class=\"nav flex-column gap-1\">\n" +
            "    <li class=\"nav-item\"><a class=\"nav-link text-light d-flex align-items-center gap-2\" href=\"" + ctx + "/admin/categories\">" +
            "<i class=\"bi bi-folder2-open\"></i>Danh M&#7909;c</a></li>\n" +
            "    <li class=\"nav-item\"><a class=\"nav-link text-light d-flex align-items-center gap-2\" href=\"" + ctx + "/admin/videos\">" +
            "<i class=\"bi bi-camera-video\"></i>Video</a></li>\n" +
            "    <li class=\"nav-item mt-3\"><a class=\"nav-link text-light d-flex align-items-center gap-2\" href=\"" + ctx + "/home\">" +
            "<i class=\"bi bi-house\"></i>Trang Ch&#7911;</a></li>\n" +
            "    <li class=\"nav-item\"><a class=\"nav-link text-danger d-flex align-items-center gap-2\" href=\"" + ctx + "/logout\">" +
            "<i class=\"bi bi-box-arrow-right\"></i>&#272;&#259;ng Xu&#7845;t</a></li>\n" +
            "  </ul>\n" +
            "</div>\n" +
            "<div id=\"main-content\">\n" +
            "  <nav class=\"navbar navbar-dark px-3 py-2 shadow-sm\" style=\"background:#1e293b\">\n" +
            "    <span class=\"navbar-brand fw-semibold text-white\">" + title + "</span>\n" +
            "    <div class=\"ms-auto\"><a class=\"btn btn-sm btn-outline-light\" href=\"" + ctx + "/home\">" +
            "<i class=\"bi bi-house me-1\"></i>Web</a></div>\n" +
            "  </nav>\n" +
            "  <div class=\"p-4\">" + content + "</div>\n" +
            "</div>\n" +
            "<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js\"></script>\n" +
            "</body>\n</html>\n";
    }
}
