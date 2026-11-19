package vn.iotstar.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Properties;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;

/**
 * Tiện ích upload hình ảnh lên Cloudinary sử dụng Cloudinary Java SDK
 * Hỗ trợ lưu trữ đám mây và cơ chế dự phòng lưu trữ nội bộ (Local Fallback)
 */
public class CloudinaryUtil {

    private static String cloudName = "";
    private static String apiKey = "";
    private static String apiSecret = "";
    private static Cloudinary cloudinary = null;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        try (InputStream input = CloudinaryUtil.class.getClassLoader().getResourceAsStream("cloudinary.properties")) {
            if (input != null) {
                Properties props = new Properties();
                props.load(input);
                cloudName = props.getProperty("cloudinary.cloud_name", "").trim();
                apiKey = props.getProperty("cloudinary.api_key", "").trim();
                apiSecret = props.getProperty("cloudinary.api_secret", "").trim();
            }
        } catch (Exception e) {
            System.err.println("[CLOUDINARY CONFIG] Không đọc được cloudinary.properties: " + e.getMessage());
        }

        // Đọc thêm từ biến môi trường nếu có
        if (System.getenv("CLOUDINARY_CLOUD_NAME") != null) {
            cloudName = System.getenv("CLOUDINARY_CLOUD_NAME").trim();
        }
        if (System.getenv("CLOUDINARY_API_KEY") != null) {
            apiKey = System.getenv("CLOUDINARY_API_KEY").trim();
        }
        if (System.getenv("CLOUDINARY_API_SECRET") != null) {
            apiSecret = System.getenv("CLOUDINARY_API_SECRET").trim();
        }

        if (isConfigured()) {
            try {
                cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", cloudName,
                    "api_key", apiKey,
                    "api_secret", apiSecret,
                    "secure", true
                ));
            } catch (Exception e) {
                System.err.println("[CLOUDINARY INIT ERROR] " + e.getMessage());
            }
        }
    }

    public static boolean isConfigured() {
        return cloudName != null && !cloudName.isEmpty() && !cloudName.equals("your_cloud_name") && !cloudName.equals("hcmute-demo")
                && apiKey != null && !apiKey.isEmpty() && !apiKey.equals("your_api_key") && !apiKey.equals("123456789012345")
                && apiSecret != null && !apiSecret.isEmpty() && !apiSecret.equals("your_api_secret");
    }

    /**
     * Upload file Part lên Cloudinary qua Multipart
     * @param part đối tượng Part nhận từ form Multipart
     * @return URL ảnh trực tuyến từ Cloudinary (hoặc tên file local nếu dùng fallback)
     */
    public static String uploadFile(Part part) {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        loadConfig();

        try {
            String submittedFileName = part.getSubmittedFileName();
            String originalName = Paths.get(submittedFileName != null ? submittedFileName : "avatar.png")
                    .getFileName().toString();
            int dotIndex = originalName.lastIndexOf(".");
            String ext = (dotIndex > 0) ? originalName.substring(dotIndex).toLowerCase() : ".png";

            // Đọc dữ liệu nhị phân từ Part
            byte[] fileBytes;
            try (InputStream is = part.getInputStream();
                 ByteArrayOutputStream os = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = is.read(buffer)) != -1) {
                    os.write(buffer, 0, len);
                }
                fileBytes = os.toByteArray();
            }

            // Nếu đã cấu hình tài khoản Cloudinary thật
            if (isConfigured() && cloudinary != null) {
                System.out.println("[CLOUDINARY] Đang tải ảnh lên Cloudinary: " + originalName);
                @SuppressWarnings("rawtypes")
                Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                    "folder", "hcmute_user_profiles",
                    "resource_type", "image"
                ));
                String secureUrl = (String) uploadResult.get("secure_url");
                System.out.println("[CLOUDINARY THÀNH CÔNG] URL ảnh: " + secureUrl);
                return secureUrl;
            } else {
                // Fallback: Lưu vào thư mục máy chủ nội bộ
                System.out.println("[CLOUDINARY THÔNG BÁO] Chưa cấu hình API Cloudinary thật (hoặc đang dùng mẫu). Tự động lưu trữ cục bộ.");
                String uploadPath = Constant.getUploadDir();
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String newFileName = "avatar_" + System.currentTimeMillis() + ext;
                part.write(uploadPath + File.separator + newFileName);
                System.out.println("[LOCAL STORAGE] Đã lưu file tại: " + uploadPath + File.separator + newFileName);
                return newFileName;
            }
        } catch (Exception e) {
            System.err.println("[UPLOAD ERROR] " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
