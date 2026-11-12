package vn.iotstar.util;

import java.io.File;

/**
 * Lop chua hang so dung chung trong he thong
 * Ho tro tuong thich da nen tang (chay duoc tren moi o dia C, D, E...)
 */
public class Constant {

    // Thu muc luu tru hinh anh upload mac dinh
    public static final String DIR = initUploadDirectory();

    // Ten Cookie Remember Me
    public static final String COOKIE_REMEMBER = "username";

    // Ten bien luu tru trong Session
    public static final String SESSION_USERNAME = "username";

    public static class Path {
        public static final String REGISTER = "/views/register.jsp";
        public static final String LOGIN = "/views/login.jsp";
        public static final String ADMIN_CATEGORY_LIST = "/views/admin/category-list.jsp";
        public static final String ADMIN_CATEGORY_ADD = "/views/admin/category-add.jsp";
        public static final String ADMIN_CATEGORY_EDIT = "/views/admin/category-edit.jsp";
    }

    /**
     * Tu dong xac dinh thu muc upload hop le tren moi may tinh:
     * 1. Uu tien E:/upload neu co o dia E
     * 2. Neu khong co o dia E, dung C:/upload
     * 3. Fallback ve {user.home}/upload
     */
    private static String initUploadDirectory() {
        File dirE = new File("E:" + File.separator + "upload");
        File driveE = new File("E:" + File.separator);
        if (driveE.exists()) {
            if (!dirE.exists()) {
                dirE.mkdirs();
            }
            return dirE.getAbsolutePath();
        }

        File dirC = new File("C:" + File.separator + "upload");
        if (!dirC.exists()) {
            dirC.mkdirs();
        }
        return dirC.getAbsolutePath();
    }

    public static String getUploadDir() {
        File dir = new File(DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dir.getAbsolutePath();
    }
}
