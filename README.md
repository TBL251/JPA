# Báo cáo bài tập: JPA 3.0, Layout Bootstrap 5, Validation và Hồ sơ Người dùng

Hệ thống web quản lý danh mục, video và hồ sơ người dùng xây dựng trên Jakarta EE 10, JPA 3.1 / Hibernate 6.5, Bootstrap 5, xác thực OTP qua Email, băm mật khẩu BCrypt và lưu trữ ảnh trên Cloudinary.

---

## Thông tin chung

* Trường: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
* Khoa: Công nghệ Thông tin
* Môn học: Lập trình Web
* Sinh viên thực hiện: Lê Bá Tám
* Mã số sinh viên (MSSV): 24110055
* Repository GitHub: [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)

---

## Mục lục

1. [Nội dung và yêu cầu bài tập](#1-nội-dung-và-yêu-cầu-bài-tập)
2. [Công nghệ và thư viện sử dụng](#2-công-nghệ-và-thư-viện-sử-dụng)
3. [Cấu trúc mã nguồn dự án](#3-cấu-trúc-mã-nguồn-dự-án)
4. [Mô hình dữ liệu và quan hệ thực thể](#4-mô-hình-dữ-liệu-và-quan-hệ-thực-thể)
5. [Chi tiết giao diện Bootstrap 5 và Validation form](#5-chi-tiết-giao-diện-bootstrap-5-và-validation-form)
6. [Chi tiết chức năng Hồ sơ cá nhân, Cloudinary và OTP đổi email](#6-chi-tiết-chức-năng-hồ-sơ-cá-nhân-cloudinary-và-otp-đổi-email)
7. [Chi tiết tính năng xác thực OTP và quản lý Video](#7-chi-tiết-tính-năng-xác-thực-otp-và-quản-lý-video)
8. [Hướng dẫn thiết lập cơ sở dữ liệu và Cloudinary](#8-hướng-dẫn-thiết-lập-cơ-sở-dữ-liệu-và-cloudinary)
9. [Hướng dẫn biên dịch và triển khai ứng dụng](#9-hướng-dẫn-biên-dịch-và-triển-khai-ứng-dụng)
10. [Bảng điều hướng URL và tài khoản kiểm thử](#10-bảng-điều-hướng-url-và-tài-khoản-kiểm-thử)

---

## 1. Nội dung và yêu cầu bài tập

Dự án hoàn thiện các nhóm chức năng chính sau:

1. Cấu hình SiteMesh Decorator 3 và Template Bootstrap 5
   * Tích hợp Bootstrap 5.3.3 và Bootstrap Icons 1.11.3 làm giao diện chung cho toàn bộ trang người dùng (navbar trên cùng) và trang quản trị (sidebar tối bên trái).
   * Tách bố cục dùng chung tại `src/main/webapp/views/layout/` (`header.jsp`, `footer.jsp`, `admin-header.jsp`, `admin-footer.jsp`) và `src/main/webapp/common/` để áp dụng đồng nhất cho toàn bộ 16 trang JSP.

2. Validation dữ liệu cho tất cả các form (login, register, forgot-password, reset-password, insert, edit)
   * Kiểm tra phía trình duyệt (client-side) bằng HTML5 constraint (`required`, `minlength`, `maxlength`, `type="email"`, `pattern`) kết hợp Bootstrap 5 `.needs-validation`.
   * Kiểm tra phía máy chủ (server-side) trong từng Servlet Controller trước khi ghi xuống cơ sở dữ liệu, giữ lại dữ liệu người dùng vừa nhập và hiển thị thông báo lỗi rõ ràng.

3. Chức năng Hồ sơ cá nhân (User Profile)
   * Cập nhật họ tên (`fullname`), số điện thoại (`phone`).
   * Đổi địa chỉ email mới: khi người dùng nhập email khác email hiện tại, hệ thống sinh mã OTP 6 chữ số và gửi đến địa chỉ email mới. Email chỉ được cập nhật vào cơ sở dữ liệu sau khi xác nhận đúng mã OTP tại `/profile/verify-otp`.
   * Cập nhật ảnh đại diện (`avatar`): nhận file qua Multipart và tải trực tiếp lên Cloudinary thông qua `CloudinaryUtil`.

4. Xác thực tài khoản OTP, băm mật khẩu BCrypt và quản lý Video / Danh mục
   * Đăng ký tài khoản kèm kích hoạt OTP qua email (`/register`, `/verify-otp`), quên mật khẩu qua OTP (`/forgot-password`, `/reset-password`), mật khẩu băm bằng BCrypt (`jBCrypt`).
   * Quản lý danh mục (`/admin/categories`) và video (`/admin/videos`) kèm upload ảnh Multipart.
   * Hiển thị 10 video mới nhất trên trang chủ (`/home`), danh sách video phân trang 6 video/trang (`/video`), và trang xem chi tiết tự tăng lượt xem (`/video/detail?id=...`).

---

## 2. Công nghệ và thư viện sử dụng

* Nền tảng: Java 17, Jakarta EE 10, Servlet 6.1, JSP 4.0, JSTL 3.0.
* Giao diện: Bootstrap 5.3.3, Bootstrap Icons 1.11.3, SiteMesh 3.3.0.
* ORM và cơ sở dữ liệu: Hibernate Core 6.5.2.Final (JPA 3.1), Hibernate Validator 8.0.1.Final, SQL Server JDBC Driver (`mssql-jdbc` 12.6.1).
* Lưu trữ ảnh đám mây: Cloudinary Java SDK (`cloudinary-http44` 1.38.0).
* Bảo mật và Email: jBCrypt 0.4, Jakarta Mail API 2.1.3 và Angus Mail 2.0.3.
* Máy chủ ứng dụng: Apache Tomcat 11.0.27.

---

## 3. Cấu trúc mã nguồn dự án

```text
src/main/
├── java/vn/iotstar/
│   ├── config/
│   │   ├── AppContextListener.java       # Khởi tạo JPA nền khi deploy, đóng kết nối khi dừng
│   │   ├── JpaConfig.java                # Quản lý EntityManagerFactory JPA 3.1
│   │   └── Test.java                     # Kiểm thử kết nối CSDL và JPA
│   ├── controller/
│   │   ├── HomeController.java           # Trang chủ: 10 video mới nhất và danh mục
│   │   ├── LoginController.java          # Đăng nhập BCrypt kèm validation
│   │   ├── LogoutController.java         # Đăng xuất và xóa cookie ghi nhớ
│   │   ├── RegisterController.java       # Đăng ký, validation và gửi OTP kích hoạt
│   │   ├── VerifyOtpController.java      # Xác thực OTP kích hoạt tài khoản
│   │   ├── ForgotPasswordController.java # Quên mật khẩu và gửi OTP qua email
│   │   ├── ResetPasswordController.java  # Đặt lại mật khẩu mới qua OTP
│   │   ├── ProfileController.java        # Hồ sơ User: update, upload Cloudinary, OTP đổi email
│   │   ├── CategoryController.java       # CRUD Danh mục sản phẩm (Admin)
│   │   ├── VideoController.java          # CRUD Video (Admin)
│   │   ├── UserVideoController.java      # Danh sách video phân trang 6 video/trang
│   │   ├── VideoDetailController.java    # Xem chi tiết và phát video
│   │   ├── WaitingController.java        # Điều hướng sau đăng nhập theo phân quyền
│   │   └── DownloadImageController.java  # Đọc và trả ảnh upload cục bộ (/image?fname=...)
│   ├── dao/
│   │   ├── ICategoryDao.java / impl/CategoryDaoImpl.java
│   │   ├── UserDao.java / impl/UserDaoImpl.java
│   │   └── IVideoDao.java / impl/VideoDaoImpl.java
│   ├── entity/
│   │   ├── Category.java                 # Thực thể Danh mục
│   │   ├── User.java                     # Thực thể Người dùng
│   │   └── Video.java                    # Thực thể Video (quan hệ với User và Category)
│   ├── service/
│   │   ├── ICategoryService.java / impl/CategoryServiceImpl.java
│   │   ├── UserService.java / impl/UserServiceImpl.java
│   │   └── IVideoService.java / impl/VideoServiceImpl.java
│   └── util/
│       ├── CloudinaryUtil.java           # Tải ảnh Multipart lên Cloudinary
│       ├── Constant.java                 # Hằng số đường dẫn và thư mục upload
│       ├── EmailUtil.java                # Gửi email SMTP và tạo mã OTP 6 chữ số
│       └── PasswordUtil.java             # Băm và kiểm tra mật khẩu BCrypt
├── resources/
│   ├── META-INF/persistence.xml          # Cấu hình JPA Persistence Unit
│   ├── cloudinary.properties.example     # File mẫu cấu hình API key Cloudinary
│   └── mail.properties                   # Cấu hình SMTP gửi email OTP
└── webapp/
    ├── META-INF/context.xml              # Tối ưu JarScanner cho Tomcat 11
    ├── WEB-INF/web.xml                   # Khai báo Servlet, Listener và Multipart
    ├── common/                           # Các thành phần layout dùng chung (header, footer, navbar)
    └── views/
        ├── layout/                       # Layout Bootstrap 5 (header, footer, admin-header, admin-footer)
        ├── admin/                        # Các trang quản trị Category và Video
        ├── profile.jsp                   # Giao diện cập nhật hồ sơ User
        ├── profile-verify-otp.jsp        # Giao diện nhập OTP xác nhận đổi email
        └── *.jsp                         # Các trang home, login, register, otp, video
```

---

## 4. Mô hình dữ liệu và quan hệ thực thể

### Bảng `users`

* `id INT IDENTITY(1,1) PRIMARY KEY`: Khóa chính.
* `username VARCHAR(50) NOT NULL UNIQUE`: Tên tài khoản.
* `password VARCHAR(255) NOT NULL`: Mật khẩu băm BCrypt.
* `email NVARCHAR(150) NULL`: Địa chỉ email nhận OTP.
* `fullname NVARCHAR(100) NULL`: Họ và tên người dùng.
* `avatar NVARCHAR(255) NULL`: Đường dẫn ảnh đại diện (URL Cloudinary hoặc file cục bộ).
* `roleid INT NOT NULL DEFAULT 3`: Phân quyền (1: Admin, 2: Manager, 3: User).
* `phone VARCHAR(20) NULL`: Số điện thoại.
* `status INT NOT NULL DEFAULT 0`: Trạng thái (0: Chưa kích hoạt, 1: Đã kích hoạt).
* `code VARCHAR(10) NULL`: Mã xác thực OTP 6 chữ số.
* `createddate DATE NULL`: Ngày tạo tài khoản.

### Bảng `videos`

* `videoId NVARCHAR(50) PRIMARY KEY`: Mã định danh video.
* `title NVARCHAR(255) NULL`: Tiêu đề video.
* `description NVARCHAR(MAX) NULL`: Mô tả nội dung.
* `poster NVARCHAR(255) NULL`: Ảnh đại diện video.
* `views INT NOT NULL DEFAULT 0`: Số lượt xem.
* `active BIT NOT NULL DEFAULT 1`: Trạng thái hiển thị (1: Hiển thị, 0: Ẩn).
* `categoryId INT NULL`: Khóa ngoại tham chiếu `categories(categoryId)`.
* `userId INT NULL`: Khóa ngoại tham chiếu `users(id)`.

### Quan hệ JPA giữa các thực thể

* `User` và `Video`: `@OneToMany(mappedBy = "user")` trong `User.java`, `@ManyToOne @JoinColumn(name = "userId")` trong `Video.java`.
* `Category` và `Video`: `@OneToMany(mappedBy = "category")` trong `Category.java`, `@ManyToOne @JoinColumn(name = "categoryId")` trong `Video.java`.

---

## 5. Chi tiết giao diện Bootstrap 5 và Validation form

### Bố cục giao diện

* Trang người dùng dùng `views/layout/header.jsp` và `views/layout/footer.jsp` với thanh điều hướng tối (`navbar-dark bg-dark`), tự động hiển thị tên tài khoản, đường dẫn `/profile`, đường dẫn `/admin/categories` (nếu là Admin/Manager) và nút đăng xuất khi đã có `sessionScope.account`.
* Trang quản trị dùng `views/layout/admin-header.jsp` và `views/layout/admin-footer.jsp` với thanh menu dọc bên trái để chuyển nhanh giữa quản lý danh mục, quản lý video và trang chủ.

### Kiểm tra hợp lệ dữ liệu (Validation)

* Form đăng nhập (`/login`): kiểm tra tên đăng nhập/email và mật khẩu không rỗng, tối thiểu 3 ký tự.
* Form đăng ký (`/register`): kiểm tra định dạng username, email hợp lệ, mật khẩu tối thiểu 6 ký tự, mật khẩu xác nhận khớp và chưa trùng username/email trong CSDL.
* Form quên mật khẩu và đặt lại mật khẩu (`/forgot-password`, `/reset-password`): kiểm tra định dạng email, mã OTP 6 chữ số và mật khẩu mới.
* Form thêm và sửa danh mục (`/admin/category/add`, `/admin/category/edit`): kiểm tra tên danh mục không để trống và độ dài hợp lệ.
* Form thêm và sửa video (`/admin/video/add`, `/admin/video/edit`): kiểm tra mã video, tiêu đề bắt buộc và danh mục hợp lệ.
* Form cập nhật hồ sơ (`/profile`): kiểm tra họ tên, định dạng số điện thoại (10–11 chữ số), định dạng email và phần mở rộng file ảnh.

---

## 6. Chi tiết chức năng Hồ sơ cá nhân, Cloudinary và OTP đổi email

1. Người dùng đã đăng nhập truy cập `/profile` để xem thông tin hiện tại (`username`, `fullname`, `phone`, `email`, `avatar`).
2. Khi nhấn lưu (`POST /profile/update`):
   * Nếu người dùng chọn file ảnh mới, `ProfileController` đọc `Part` từ Multipart và gọi `CloudinaryUtil.uploadImage(...)` để tải ảnh lên Cloudinary, lấy về URL `secure_url` lưu vào trường `avatar`.
   * Cập nhật ngay `fullname`, `phone` và `avatar` vào cơ sở dữ liệu cùng đối tượng `account` trong session.
   * Nếu địa chỉ `email` mới khác với `email` hiện tại: hệ thống kiểm tra email mới chưa thuộc về tài khoản khác, sinh mã OTP 6 chữ số, gửi email xác thực tới địa chỉ email mới qua `EmailUtil` và lưu trạng thái chờ xác nhận trong session.
3. Người dùng được chuyển tới `/profile/verify-otp` để nhập mã OTP (có nút gửi lại mã qua `/profile/resend-otp`). Khi mã OTP khớp, email mới mới được ghi vào cơ sở dữ liệu.

---

## 7. Chi tiết tính năng xác thực OTP và quản lý Video

* Kích hoạt tài khoản và quên mật khẩu: sử dụng `EmailUtil.generateOtp()` tạo mã 6 số, lưu vào cột `users.code` và gửi qua Gmail SMTP. Trường hợp chạy cục bộ không kết nối SMTP, mã OTP được in ra console của Tomcat để kiểm thử.
* Trang chủ (`/home`): truy vấn JPQL lấy 10 video mới nhất đang hoạt động (`active = true`) kèm danh sách danh mục.
* Danh sách video (`/video`): phân trang JPA với `setFirstResult((page - 1) * 6)` và `setMaxResults(6)`.
* Xem chi tiết video (`/video/detail?id=...`): tăng `views` lên 1 mỗi lần mở, hiển thị trình phát HTML5 và danh sách video gợi ý.

---

## 8. Hướng dẫn thiết lập cơ sở dữ liệu và Cloudinary

### Cơ sở dữ liệu SQL Server

1. Chạy file `database.sql` để tạo cơ sở dữ liệu `webst2`, các bảng `categories`, `users`, `videos` và dữ liệu mẫu:

   ```cmd
   sqlcmd -S 127.0.0.1,1433 -U sa -P "1234567@a$" -i database.sql
   ```

2. Bật giao thức TCP/IP cổng `1433` trên SQL Server (có thể dùng script `enable-sql-tcp.bat`).

### Cấu hình Cloudinary (tùy chọn cho upload ảnh đám mây)

1. Sao chép file `src/main/resources/cloudinary.properties.example` thành `src/main/resources/cloudinary.properties` (file này đã được đưa vào `.gitignore` để không lộ khóa API).
2. Điền thông tin tài khoản Cloudinary (`cloud_name`, `api_key`, `api_secret`) hoặc thiết lập biến môi trường tương ứng.

---

## 9. Hướng dẫn biên dịch và triển khai ứng dụng

1. Chạy script biên dịch và đóng gói:

   ```cmd
   build.bat
   ```

   Script biên dịch dự án bằng Maven (`mvn clean package -DskipTests`), tạo file `target\JPA_Servlet_Category.war` và sao chép vào thư mục `webapps` của Tomcat (`E:\apache-tomcat-11.0.27\webapps`).

2. Khởi động Apache Tomcat 11:

   ```cmd
   E:\apache-tomcat-11.0.27\bin\startup.bat
   ```

3. Đợi khoảng 10–15 giây để Tomcat giải nén WAR và khởi tạo JPA, sau đó truy cập:

   ```text
   http://localhost:8080/JPA_Servlet_Category/home
   ```

---

## 10. Bảng điều hướng URL và tài khoản kiểm thử

### Bảng danh sách URL chính

| Chức năng | Đường dẫn (URL) | Ghi chú |
| :--- | :--- | :--- |
| Trang chủ | `/home` | Hiển thị 10 video mới nhất và danh mục |
| Video của User | `/video` | Phân trang 6 video/trang |
| Chi tiết và phát Video | `/video/detail?id=v01` | Tự động tăng lượt xem |
| Hồ sơ cá nhân | `/profile` | Cập nhật fullname, phone, avatar Cloudinary |
| Xác thực OTP đổi email | `/profile/verify-otp` | Xác nhận OTP gửi tới email mới |
| Đăng ký tài khoản | `/register` | Tạo tài khoản và gửi mã OTP kích hoạt |
| Xác thực OTP đăng ký | `/verify-otp` | Kích hoạt tài khoản |
| Đăng nhập | `/login` | Xác thực mật khẩu BCrypt |
| Quên mật khẩu | `/forgot-password` | Gửi mã OTP đặt lại mật khẩu |
| Đặt lại mật khẩu | `/reset-password` | Đổi mật khẩu bằng mã OTP |
| Đăng xuất | `/logout` | Xóa phiên đăng nhập và cookie |
| Quản trị Danh mục | `/admin/categories` | CRUD danh mục (`/admin/category/add`, `edit`, `delete`) |
| Quản trị Video | `/admin/videos` | CRUD video (`/admin/video/add`, `edit`, `delete`) |

### Tài khoản kiểm thử mặc định

* Quản trị viên (Admin): `admin` / `123`
* Người dùng (User): `user` / `123`
