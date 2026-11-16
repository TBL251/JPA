# Báo cáo bài tập: Mở rộng JPA 3.0, Xác thực OTP, Quản lý Video và Phân quyền

Hệ thống quản lý danh mục sản phẩm, video đa phương tiện với xác thực OTP qua Email, băm mật khẩu bảo mật BCrypt và kiến trúc JPA 3.0 / Jakarta EE 10.

---

## Thông tin chung

* Trường: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
* Khoa: Công nghệ Thông tin
* Bộ môn: Kỹ thuật Phần mềm / Công nghệ Web
* Môn học: Lập trình Web
* Sinh viên thực hiện: Lê Bá Tám
* Mã số sinh viên (MSSV): 24110055
* Đường dẫn repository GitHub: [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)

---

## Mục lục

1. [Nội dung và yêu cầu bài tập](#1-nội-dung-và-yêu-cầu-bài-tập)
2. [Công nghệ và thư viện sử dụng](#2-công-nghệ-và-thư-viện-sử-dụng)
3. [Cấu trúc mã nguồn dự án](#3-cấu-trúc-mã-nguồn-dự-án)
4. [Mô hình dữ liệu và quan hệ thực thể](#4-mô-hình-dữ-liệu-và-quan-hệ-thực-thể)
5. [Chi tiết tính năng xác thực OTP và bảo mật](#5-chi-tiết-tính-năng-xác-thực-otp-và-bảo-mật)
6. [Chi tiết tính năng quản lý Video và phát video](#6-chi-tiết-tính-năng-quản-lý-video-và-phát-video)
7. [Hướng dẫn xử lý upload file bằng Multipart](#7-hướng-dẫn-xử-lý-upload-file-bằng-multipart)
8. [Hướng dẫn thiết lập cơ sở dữ liệu SQL Server](#8-hướng-dẫn-thiết-lập-cơ-sở-dữ-liệu-sql-server)
9. [Hướng dẫn biên dịch và triển khai ứng dụng](#9-hướng-dẫn-biên-dịch-và-triển-khai-ứng-dụng)
10. [Bảng điều hướng URL và tài khoản kiểm thử](#10-bảng-điều-hướng-url-và-tài-khoản-kiểm-thử)

---

## 1. Nội dung và yêu cầu bài tập

Dự án hoàn thiện các yêu cầu mở rộng trên nền tảng JPA 3.0 và Jakarta EE 10:

1. **Kích hoạt tài khoản bằng mã OTP gửi qua Email**
   * Khi đăng ký tài khoản (`/register`), người dùng điền thông tin và địa chỉ email nhận mã.
   * Tài khoản được tạo ở trạng thái chưa kích hoạt (`status = 0`), mã OTP 6 chữ số được tạo ngẫu nhiên và lưu vào cơ sở dữ liệu (`users.code`).
   * Hệ thống gửi email chứa mã OTP đến hòm thư người dùng qua Jakarta Mail (Gmail SMTP).
   * Chuyển hướng người dùng sang trang `/verify-otp`. Khi nhập chính xác mã OTP, tài khoản chuyển sang trạng thái kích hoạt (`status = 1`), cho phép đăng nhập.

2. **Đăng nhập với mật khẩu được mã hóa (Hash Password) và Đăng xuất**
   * Sử dụng thuật toán BCrypt với chuỗi muối ngẫu nhiên (`jBCrypt`) để băm mật khẩu khi lưu trữ.
   * Xác thực đăng nhập qua hàm kiểm tra băm bảo mật, hỗ trợ tương thích tài khoản cũ.
   * Ngăn chặn đăng nhập nếu tài khoản chưa kích hoạt OTP (`status = 0`), hướng dẫn người dùng tới trang xác thực.
   * Chức năng đăng xuất (`/logout`) hủy phiên làm việc và xóa cookie ghi nhớ.

3. **Quên mật khẩu gửi mã xác nhận OTP qua Email**
   * Người dùng nhập địa chỉ email đã đăng ký tại `/forgot-password`.
   * Hệ thống tạo mã OTP mới, lưu vào CSDL và gửi email xác nhận.
   * Chuyển hướng sang `/reset-password` để người dùng nhập OTP và đổi mật khẩu mới bảo mật.

4. **Thêm bảng `Videos` có quan hệ 1-n với bảng `users`**
   * Tạo bảng `videos` với khóa ngoại `userId` trỏ tới `users(id)` và khóa ngoại `categoryId` trỏ tới `categories(categoryId)`.
   * Xây dựng Entity `Video.java` với các annotation JPA 3.0 (`@ManyToOne`, `@JoinColumn`).
   * Xây dựng đầy đủ tầng `VideoDao` và `VideoService`.

5. **Quản lý Video (CRUD) cho Admin và Phân quyền**
   * Giao diện quản lý danh sách video (`/admin/videos`) với tính năng xem, thêm, sửa, xóa.
   * Hỗ trợ upload ảnh đại diện (Poster) đa phương tiện bằng chuẩn Multipart của Jakarta Servlet.

6. **Hiển thị 10 video mới nhất trên trang chủ (`/home`)**
   * Truy vấn lấy 10 video có trạng thái hoạt động mới nhất theo mã hoặc ngày tạo.
   * Hiển thị lưới thẻ video trực quan kèm thông tin người tải lên, số lượt xem và liên kết phát video.

7. **Hiển thị danh sách video của User với phân trang 6 video/trang (`/video`)**
   * Phân trang JPA với `setFirstResult` và `setMaxResults` (6 video trên 1 trang).
   * Điều hướng trang (trước, các trang số, sau) mượt mà.

8. **Hiển thị chi tiết và phát video (Play Video) khi bấm vào tiêu đề**
   * Mở trang xem video (`/video/detail?id=...`) với trình phát HTML5 responsive.
   * Tự động tăng lượt xem (`views`) mỗi khi người dùng mở video.
   * Hiển thị thông tin tác giả, danh mục và danh sách video gợi ý liên quan.

---

## 2. Công nghệ và thư viện sử dụng

* **Nền tảng chính:** Java 17 (JBR 17), Jakarta EE 10, Servlet 6.0, JSP 3.1.
* **ORM & Database:** Hibernate Core 6.6.x (JPA 3.0), SQL Server JDBC Driver (`mssql-jdbc:12.8.1.jre11`).
* **Bảo mật & Mã hóa:** jBCrypt 0.4 (Băm mật khẩu `BCrypt.hashpw` và `BCrypt.checkpw`).
* **Dịch vụ Email:** Jakarta Mail API 2.1.3 (`jakarta.mail-api`) và Angus Mail 2.0.3 (`org.eclipse.angus:angus-mail`).
* **Template Engine:** JSTL 3.0.0 (`jakarta.servlet.jsp.jstl`).
* **Máy chủ ứng dụng:** Apache Tomcat 11.0.27.

---

## 3. Cấu trúc mã nguồn dự án

```text
src/main/java/vn/iotstar/
├── config/
│   ├── JpaConfig.java               # Cấu hình EntityManagerFactory JPA 3.0
│   └── Test.java                    # Script kiểm thử kết nối CSDL và ORM
├── controller/
│   ├── HomeController.java          # Trang chủ: 10 video mới nhất & danh mục
│   ├── LoginController.java         # Đăng nhập bảo mật BCrypt
│   ├── LogoutController.java        # Đăng xuất phiên làm việc
│   ├── RegisterController.java      # Đăng ký tài khoản và gửi mã OTP
│   ├── VerifyOtpController.java     # Xác thực mã OTP kích hoạt tài khoản
│   ├── ForgotPasswordController.java# Gửi mã OTP lấy lại mật khẩu
│   ├── ResetPasswordController.java # Đổi mật khẩu mới qua OTP
│   ├── VideoController.java         # Danh sách video phân trang và phát video
│   ├── DownloadFileController.java  # Tải và hiển thị ảnh upload Multipart
│   └── admin/
│       ├── CategoryController.java  # CRUD Danh mục sản phẩm
│       └── VideoController.java     # CRUD Quản trị video
├── dao/
│   ├── ICategoryDao.java / impl/CategoryDaoImpl.java
│   ├── IUserDao.java / impl/UserDaoImpl.java
│   └── IVideoDao.java / impl/VideoDaoImpl.java
├── entity/
│   ├── Category.java                # Thực thể Danh mục
│   ├── User.java                    # Thực thể Người dùng (status, code, BCrypt)
│   └── Video.java                   # Thực thể Video (quan hệ với User và Category)
├── service/
│   ├── ICategoryService.java / impl/CategoryServiceImpl.java
│   ├── IUserService.java / impl/UserServiceImpl.java
│   └── IVideoService.java / impl/VideoServiceImpl.java
└── util/
    ├── Constant.java                # Hằng số đường dẫn và thư mục upload
    ├── EmailUtil.java               # Gửi email thật qua SMTP và sinh mã OTP
    └── PasswordUtil.java            # Băm và kiểm tra mật khẩu BCrypt
```

---

## 4. Mô hình dữ liệu và quan hệ thực thể

### Bảng `users`

* `id INT IDENTITY(1,1) PRIMARY KEY`: Khóa chính.
* `username VARCHAR(50) NOT NULL UNIQUE`: Tên tài khoản.
* `password VARCHAR(255) NOT NULL`: Mật khẩu được băm bằng BCrypt.
* `email NVARCHAR(150) NULL`: Địa chỉ email nhận OTP.
* `fullname NVARCHAR(100) NULL`: Họ và tên người dùng.
* `avatar NVARCHAR(255) NULL`: Ảnh đại diện.
* `roleid INT NOT NULL DEFAULT 3`: Phân quyền (1: Admin, 2: Manager, 3: User).
* `phone VARCHAR(20) NULL`: Số điện thoại.
* `status INT NOT NULL DEFAULT 0`: Trạng thái (0: Chưa kích hoạt, 1: Đã kích hoạt qua OTP).
* `code VARCHAR(10) NULL`: Mã xác thực OTP 6 số ngẫu nhiên.
* `createddate DATE NULL`: Ngày đăng ký.

### Bảng `videos`

* `videoId NVARCHAR(50) PRIMARY KEY`: Mã định danh video.
* `title NVARCHAR(255) NULL`: Tiêu đề video.
* `description NVARCHAR(MAX) NULL`: Mô tả nội dung.
* `poster NVARCHAR(255) NULL`: Đường dẫn ảnh đại diện video (tệp tin tải lên hoặc URL).
* `views INT NOT NULL DEFAULT 0`: Số lượt xem (tự động tăng khi mở xem chi tiết).
* `active BIT NOT NULL DEFAULT 1`: Trạng thái hiển thị (1: Hiển thị, 0: Ẩn).
* `categoryId INT NULL`: Khóa ngoại tham chiếu `categories(categoryId)`.
* `userId INT NULL`: Khóa ngoại tham chiếu `users(id)`.

### Quan hệ JPA giữa các thực thể

* Quan hệ giữa `User` và `Video`: `@OneToMany(mappedBy = "user")` trong `User.java` và `@ManyToOne @JoinColumn(name = "userId")` trong `Video.java`.
* Quan hệ giữa `Category` và `Video`: `@OneToMany(mappedBy = "category")` trong `Category.java` và `@ManyToOne @JoinColumn(name = "categoryId")` trong `Video.java`.

---

## 5. Chi tiết tính năng xác thực OTP và bảo mật

### Quy trình kích hoạt tài khoản bằng mã OTP

1. Người dùng nhập thông tin tại `/register`.
2. Hệ thống kiểm tra trùng lặp `username` và `email`.
3. Sinh mã OTP 6 số qua hàm `EmailUtil.generateOtp()`.
4. Mật khẩu được băm qua `PasswordUtil.hashPassword()`.
5. Tạo bản ghi người dùng với `status = 0`, lưu mã `code` vào CSDL.
6. Gửi email chứa mã OTP đến người dùng.
7. Chuyển hướng sang `/verify-otp?email=...`. Người dùng nhập mã OTP.
8. Khi mã khớp, cập nhật `status = 1` và xóa trường `code`. Tài khoản có thể đăng nhập ngay lập tức.
9. Trường hợp kiểm thử khi không có kết nối SMTP ngoài: Mã OTP luôn được xuất trực tiếp tại cửa sổ console log của Tomcat để quá trình kiểm tra không bị gián đoạn.

### Quy trình đăng nhập và băm mật khẩu

1. Người dùng gửi thông tin tại `/login`.
2. Hàm `PasswordUtil.checkPassword(plain, hashed)` kiểm tra độ khớp của mật khẩu băm BCrypt.
3. Nếu đúng thông tin nhưng tài khoản có `status == 0`, hệ thống thông báo lỗi kèm đường dẫn đến trang `/verify-otp`.
4. Nếu tài khoản hợp lệ (`status == 1`), phiên đăng nhập được lưu vào `session.setAttribute("account", user)`.

### Quy trình quên mật khẩu bằng OTP

1. Người dùng nhập email tại `/forgot-password`.
2. Hệ thống tìm người dùng tương ứng, sinh mã OTP mới và cập nhật vào `users.code`.
3. Gửi email thông báo mã xác thực tới người dùng.
4. Chuyển hướng tới `/reset-password?email=...`.
5. Người dùng nhập mã OTP, mật khẩu mới và xác nhận mật khẩu mới.
6. Sau khi xác thực hợp lệ, mật khẩu mới được băm và lưu vào CSDL, xóa mã OTP.

---

## 6. Chi tiết tính năng quản lý Video và phát video

### 1. Hiển thị 10 video mới nhất trên trang chủ (`/home`)

* Truy vấn JPQL:

  ```sql
  SELECT v FROM Video v WHERE v.active = true ORDER BY v.videoId DESC
  ```

* Thiết lập giới hạn `.setMaxResults(10)`.
* Hiển thị dạng thẻ lưới với poster, số lượt xem, người tải lên và tiêu đề.
* Người dùng click chuột vào tiêu đề video sẽ được chuyển tiếp sang trang phát video chi tiết.

### 2. Danh sách video của User phân trang 6 video/trang (`/video`)

* URL truy cập: `/video` hoặc `/video?page=1`.
* Khi người dùng đã đăng nhập, hệ thống lọc các video thuộc quyền sở hữu của người dùng hiện tại (`user.id`). Nếu người dùng chưa đăng nhập, hệ thống hiển thị danh sách video gợi ý chung.
* Sử dụng kỹ thuật phân trang JPA:

  ```java
  query.setFirstResult((page - 1) * 6);
  query.setMaxResults(6);
  ```

* Tính tổng số trang: `totalPages = (int) Math.ceil((double) totalVideos / 6)`.
* Thanh điều hướng trang hiển thị nút trước, danh sách số trang và nút sau.

### 3. Chi tiết và phát video (`/video/detail?id=...`)

* Nhận tham số `id` của video.
* Tự động gọi phương thức `increaseViews(id)` để tăng số lượt xem lên 1.
* Trình phát video HTML5 Responsive hỗ trợ định dạng MP4 cùng ảnh poster xem trước.
* Hiển thị thông tin người đăng, danh mục liên kết, lượt xem và mô tả chi tiết.
* Cột bên cạnh hiển thị danh sách các video đề xuất khác, cho phép bấm chuyển video liên tục.

### 4. Quản trị Video (CRUD)

* Endpoint `/admin/videos`: Liệt kê bảng danh sách video với các cột Poster, Tiêu đề, Danh mục, Người đăng, Lượt xem, Trạng thái.
* Endpoint `/admin/video/add`: Thêm video mới với tùy chọn tải ảnh poster qua Multipart hoặc dán URL trực tiếp.
* Endpoint `/admin/video/edit?id=...`: Chỉnh sửa thông tin video.
* Endpoint `/admin/video/delete?id=...`: Xóa video khỏi hệ thống.

---

## 7. Hướng dẫn xử lý upload file bằng Multipart

Cấu hình Servlet hỗ trợ Multipart theo tiêu chuẩn Jakarta EE 10:

```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 50,      // 50MB
    maxRequestSize = 1024 * 1024 * 100    // 100MB
)
```

Xử lý lưu file trong Servlet:

```java
Part part = req.getPart("posterFile");
if (part != null && part.getSize() > 0) {
    String uploadPath = Constant.getUploadDir();
    String submittedFileName = part.getSubmittedFileName();
    String ext = submittedFileName.substring(submittedFileName.lastIndexOf("."));
    String newFileName = System.currentTimeMillis() + ext;
    part.write(uploadPath + File.separator + newFileName);
    video.setPoster(newFileName);
}
```

Thư mục lưu trữ: Hệ thống tự động phát hiện phân vùng đĩa sẵn có (`E:\upload`, `C:\upload` hoặc thư mục người dùng) và tự động tạo thư mục nếu chưa tồn tại.

---

## 8. Hướng dẫn thiết lập cơ sở dữ liệu SQL Server

1. Mở SQL Server Management Studio (SSMS) hoặc Azure Data Studio.
2. Mở file `database.sql` trong thư mục gốc dự án.
3. Chạy toàn bộ nội dung script để tạo cơ sở dữ liệu `webst2`, bảng `categories`, `users`, `videos` và dữ liệu mẫu:

   ```cmd
   sqlcmd -S 127.0.0.1,1433 -U sa -P "1234567@a$" -i database.sql
   ```

4. Đảm bảo dịch vụ SQL Server đã bật giao thức TCP/IP trên cổng 1433. Nếu cần bật tự động, có thể chạy tệp `enable-sql-tcp.bat`.

---

## 9. Hướng dẫn biên dịch và triển khai ứng dụng

### Biên dịch tự động qua script

1. Chạy file `build.bat` tại thư mục dự án:

   ```cmd
   build.bat
   ```

   Script sẽ tự động:

   * Biên dịch mã nguồn với Maven và JDK 17.
   * Tạo tệp `target\JPA_Servlet_Category.war`.
   * Tự động sao chép file WAR vào thư mục `webapps` của Apache Tomcat (`E:\apache-tomcat-11.0.27\webapps` hoặc `C:\apache-tomcat-11.0.27\webapps`).

### Khởi động máy chủ Tomcat

1. Chạy tệp `run-tomcat.bat` hoặc chạy trực tiếp `startup.bat` trong thư mục Tomcat:

   ```cmd
   E:\apache-tomcat-11.0.27\bin\startup.bat
   ```

2. Truy cập ứng dụng tại địa chỉ:

   ```text
   http://localhost:8080/JPA_Servlet_Category/home
   ```

---

## 10. Bảng điều hướng URL và tài khoản kiểm thử

### Bảng danh sách URL chính

| Chức năng | Đường dẫn (URL) | Ghi chú |
| :--- | :--- | :--- |
| **Trang chủ** | `/home` | Hiển thị 10 video mới nhất và danh mục |
| **Video của User** | `/video` | Phân trang 6 video/trang |
| **Phát & Chi tiết Video** | `/video/detail?id=v01` | Mở xem khi bấm vào tiêu đề video |
| **Đăng ký tài khoản** | `/register` | Nhập thông tin, tạo mã OTP |
| **Xác thực OTP** | `/verify-otp` | Kích hoạt tài khoản người dùng |
| **Đăng nhập** | `/login` | Xác thực mật khẩu băm BCrypt |
| **Quên mật khẩu** | `/forgot-password` | Nhận mã OTP đổi mật khẩu qua email |
| **Đặt lại mật khẩu** | `/reset-password` | Nhập mã OTP và mật khẩu mới |
| **Đăng xuất** | `/logout` | Xóa phiên đăng nhập |
| **Quản trị Videos** | `/admin/videos` | CRUD danh sách video |
| **Thêm Video mới** | `/admin/video/add` | Hỗ trợ upload ảnh Multipart |
| **Quản trị Danh mục** | `/admin/categories` | CRUD danh mục sản phẩm JPA |

### Tài khoản mẫu kiểm thử

* **Tài khoản Quản trị viên (Admin)**
  * Tên đăng nhập: `admin`
  * Mật khẩu: `123` (hoặc `123456`)
  * Vai trò: Toàn quyền quản trị danh mục và video
* **Tài khoản Người dùng (User)**
  * Tên đăng nhập: `user`
  * Mật khẩu: `123` (hoặc `123456`)
  * Vai trò: Xem video cá nhân, xem chi tiết và phát video
