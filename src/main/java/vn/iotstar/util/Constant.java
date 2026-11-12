package vn.iotstar.util;

import java.io.File;

/**
 * Lớp chứa hằng số dùng chung trong hệ thống
 */
public class Constant {

    // Thư mục lưu trữ hình ảnh upload
    public static final String DIR = "E:\\upload";

    // Tên Cookie Remember Me
    public static final String COOKIE_REMEMBER = "username";

    // Tên biến lưu trữ trong Session
    public static final String SESSION_USERNAME = "username";

    public static class Path {
        public static final String REGISTER = "/views/register.jsp";
        public static final String LOGIN = "/views/login.jsp";
        public static final String ADMIN_CATEGORY_LIST = "/views/admin/category-list.jsp";
        public static final String ADMIN_CATEGORY_ADD = "/views/admin/category-add.jsp";
        public static final String ADMIN_CATEGORY_EDIT = "/views/admin/category-edit.jsp";
    }

    /**
     * Lấy thư mục upload hợp lệ, tự động tạo thư mục nếu chưa tồn tại
     */
    public static String getUploadDir() {
        File dir = new File(DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dir.getAbsolutePath();
    }
}

