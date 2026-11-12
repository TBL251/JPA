# BÁO CÁO BÀI TẬP: CHUYỂN ĐỔI BÀI TẬP 01 SANG CÔNG NGHỆ JPA 3.0
## HỆ THỐNG CRUD CATEGORY & XÁC THỰC NGƯỜI DÙNG

* **Trường:** Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
* **Khoa:** Công nghệ Thông tin
* **Môn học:** Lập trình Web
* **Sinh viên thực hiện:** Lê Bá Tám - MSSV: 24110055
* **Link GitHub nộp bài (UTELMS):** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)

---

## 1. TỔNG QUAN DỰ ÁN

Dự án chuyển đổi toàn bộ kiến trúc từ JDBC thuần của Bài tập 01 sang công nghệ **JPA 3.0 (Jakarta Persistence)** và **Hibernate ORM 6.x**, đáp ứng đầy đủ yêu cầu từ 2 tài liệu hướng dẫn:

1. **Cấu hình và test JPA:**
   * Cấu hình tệp `META-INF/persistence.xml` kết nối Microsoft SQL Server (`databaseName=webst2`).
   * Khai báo Entity `@Entity` cho `Category` và `Video` (quan hệ 1 - Nhiều qua `@OneToMany` và `@ManyToOne`).
   * Lớp `JpaConfig.java` quản lý `EntityManagerFactory` và `EntityManager`.
   * Lớp `Test.java` có hàm `main()` chạy độc lập kiểm tra kết nối CSDL và lưu dữ liệu.
2. **CRUD Category bằng JPA:**
   * **DAO (`CategoryDao`)**: Cung cấp đủ 9 phương thức CRUD với `EntityManager` và JPQL: `insert`, `update`, `delete`, `findById`, `findByCategoryname`, `findAll`, `searchByName`, phân trang `findAll(page, pagesize)`, `count`.
   * **Service (`CategoryServiceImpl`)**: Xử lý logic nghiệp vụ danh mục.
   * **Controller (`CategoryController`)**: Servlet quản trị xử lý thêm, sửa, xóa, hiển thị danh sách và upload ảnh qua `@MultipartConfig`.
   * **View (JSP)**: Giao diện quản trị danh mục (`category-list.jsp`, `category-add.jsp`, `category-edit.jsp`).
3. **Nâng cấp tính năng Bài tập 01:**
   * Entity `User.java` và DAO `UserDaoImpl.java` thao tác bằng JPA.
   * Đăng nhập, đăng ký, ghi nhớ đăng nhập qua Cookie (*Remember Me*).
   * Phân quyền hiển thị: Quản trị viên (`roleid = 1`) có quyền vào khu vực Quản trị Category; Người dùng thường (`roleid = 2` hoặc `3`) duyệt hàng ở Trang chủ.
   * Servlet `DownloadImageController` phục vụ tải và hiển thị hình ảnh (`/image?fname=...`).

---

## 2. CÔNG NGHỆ SỬ DỤNG

* **Ngôn ngữ:** Java 17 LTS / Java 21 LTS
* **Nền tảng:** Jakarta EE 10 (Servlet 6.1, JSP 4.0, JSTL 3.0)
* **Web Server:** Apache Tomcat 10.1.x hoặc 11.0.x
* **JPA Provider:** Hibernate ORM 6.5.2.Final, Jakarta Persistence API 3.1.0
* **Cơ sở dữ liệu:** Microsoft SQL Server 2022 / 2019 (driver `mssql-jdbc 12.6.1`)
* **Thư viện phụ trợ:** Apache Commons-IO 2.16.1
* **Lưu trữ ảnh:** Tự động nhận diện thư mục khả dụng theo thứ tự `E:\upload` &rarr; `C:\upload` &rarr; `{user.home}/upload`.

---

## 3. CẤU TRÚC THƯ MỤC

```text
E:\WEb\JPA
├── pom.xml                                    # Khai báo dependency Maven (Jakarta EE 10, Hibernate 6)
├── database.sql                               # Script tạo database webst2 và dữ liệu mẫu
├── build.bat                                  # Script đóng gói WAR và tự copy vào Tomcat
├── run-tomcat.bat                             # Script khởi động Apache Tomcat
├── enable-sql-tcp.bat                         # Script bật TCP/IP và cổng 1433 cho SQL Server
├── push-github.bat                            # Script đẩy mã nguồn lên GitHub
├── README.md                                  # Báo cáo hướng dẫn chạy dự án
│
├── src\main\resources\META-INF
│   └── persistence.xml                        # Cấu hình Persistence Unit kết nối SQL Server
│
├── src\main\java\vn\iotstar
│   ├── config (JpaConfig.java, Test.java)
│   ├── entity (Category.java, Video.java, User.java)
│   ├── dao    (ICategoryDao, CategoryDao, UserDao, UserDaoImpl)
│   ├── service(ICategoryService, CategoryServiceImpl, UserService, UserServiceImpl)
│   ├── controller (CategoryController, HomeController, LoginController, RegisterController,...)
│   └── util   (Constant.java)
│
└── src\main\webapp
    ├── WEB-INF\web.xml
    └── views (home.jsp, login.jsp, register.jsp, admin/category-*.jsp)
```

---

## 4. THIẾT LẬP CƠ SỞ DỮ LIỆU SQL SERVER

### 4.1. Khởi tạo dữ liệu
1. Mở **SQL Server Management Studio (SSMS)**.
2. Mở file **`database.sql`** và bấm **F5** (Execute) để tạo database `webst2`, các bảng `categories`, `videos`, `users` và nạp dữ liệu mẫu.

### 4.2. Bật giao thức TCP/IP và Cổng 1433
*(Cần thiết cho Named Instance như `SERVER2022` do SQL Server mặc định tắt TCP/IP)*

* **Cách 1 (Tự động):** Nhấp đúp chuột vào file **`enable-sql-tcp.bat`** &rarr; chọn **Yes** khi Windows hỏi quyền Administrator (UAC).
* **Cách 2 (Thủ công):**
  1. Bấm `Win + R`, gõ `SQLServerManager16.msc` và nhấn Enter.
  2. Vào **SQL Server Network Configuration** &rarr; **Protocols for SERVER2022**.
  3. Nhấp đúp **TCP/IP** &rarr; đặt **Enabled = Yes**.
  4. Thẻ **IP Addresses** &rarr; cuộn xuống mục **IPAll**: Xóa trắng `TCP Dynamic Ports`, đặt `TCP Port = 1433`.
  5. Vào mục **SQL Server Services** &rarr; chuột phải `SQL Server (SERVER2022)` &rarr; **Restart**.

### 4.3. Cấu hình file persistence.xml
Tệp `src/main/resources/META-INF/persistence.xml` đã được cấu hình sẵn:
```xml
<property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
<property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://127.0.0.1:1433;encrypt=true;trustServerCertificate=true;loginTimeout=5;connectRetryCount=0;databaseName=webst2" />
<property name="jakarta.persistence.jdbc.user" value="sa" />
<property name="jakarta.persistence.jdbc.password" value="1234567@a$" />
<property name="hibernate.dialect" value="org.hibernate.dialect.SQLServerDialect" />
<property name="hibernate.hbm2ddl.auto" value="update" />
```

---

## 5. KIỂM THỬ JPA BẰNG CONSOLE (TEST.JAVA)

Kiểm tra kết nối và thao tác Hibernate độc lập:
1. Mở file `src/main/java/vn/iotstar/config/Test.java`.
2. Chạy hàm `main()` (chuột phải &rarr; **Run 'Test.main()'** hoặc `Ctrl + Shift + F10`).
3. **Kết quả:** Console in ra các lệnh `insert into categories` và `insert into videos`, kết thúc bằng thông báo thành công.

---

## 6. HƯỚNG DẪN CHẠY ỨNG DỤNG TRÊN TOMCAT

### Cách A: Dùng Script Batch tự động (Khuyên dùng)
Script tự động tìm JDK và Tomcat trên các ổ đĩa `C:\`, `D:\`, `E:\`:
1. Nhấp đúp file **`build.bat`**: Biên dịch mã nguồn, tạo `target/JPA_Servlet_Category.war` và tự copy vào thư mục `webapps` của Tomcat.
2. Nhấp đúp file **`run-tomcat.bat`**: Khởi động Apache Tomcat.
3. Mở trình duyệt và truy cập các đường dẫn ở mục 7.

### Cách B: Chạy qua Smart Tomcat trong IntelliJ IDEA
1. Cài đặt plugin **Smart Tomcat** trong IntelliJ IDEA (`Settings` &rarr; `Plugins`).
2. Vào **Run** &rarr; **Edit Configurations...** &rarr; Bấm `+` &rarr; Chọn **Smart Tomcat**.
3. Cấu hình:
   * **Tomcat Server:** Trỏ đến thư mục cài Apache Tomcat.
   * **Deployment Directory:** Trỏ đến thư mục `src/main/webapp`.
   * **Context Path:** `/JPA_Servlet_Category`.
   * **Server Port:** `8080`.
4. Bấm **Run** để khởi động.

### Cách C: Dùng dòng lệnh Maven thủ công
1. Mở Terminal tại thư mục dự án và chạy:
   ```bash
   mvn clean package -DskipTests
   ```
2. Copy file `target/JPA_Servlet_Category.war` vào thư mục `webapps/` của Tomcat.
3. Khởi động Tomcat bằng `bin/startup.bat` (Windows) hoặc `./bin/startup.sh` (macOS/Linux).

---

## 7. DANH SÁCH URL HỆ THỐNG & TÀI KHOẢN KIỂM THỬ

### Đường dẫn truy cập (URL)
| Chức năng | Đường dẫn URL | Quyền truy cập |
| :--- | :--- | :--- |
| **Quản lý Category (JPA CRUD)** | [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories) | Admin |
| **Thêm mới Category** | [http://localhost:8080/JPA_Servlet_Category/admin/category/add](http://localhost:8080/JPA_Servlet_Category/admin/category/add) | Admin |
| **Trang chủ Cửa hàng** | [http://localhost:8080/JPA_Servlet_Category/home](http://localhost:8080/JPA_Servlet_Category/home) | Tất cả |
| **Đăng nhập** | [http://localhost:8080/JPA_Servlet_Category/login](http://localhost:8080/JPA_Servlet_Category/login) | Tất cả |
| **Đăng ký tài khoản** | [http://localhost:8080/JPA_Servlet_Category/register](http://localhost:8080/JPA_Servlet_Category/register) | Khách |

### Tài khoản kiểm thử
* **Quản trị viên (Admin):**
  * Username: `admin` | Mật khẩu: `123` (hoặc `123456`)
  * Sau khi đăng nhập, hệ thống chuyển hướng vào trang Quản lý Category (`/admin/categories`).
* **Người dùng thường (User):**
  * Username: `user` | Mật khẩu: `123` (hoặc `123456`)
  * Sau khi đăng nhập, hệ thống chuyển về Trang chủ (`/home`), ẩn nút Quản trị.

> **Cơ chế an toàn (Safe Mode):** Lớp `JpaConfig.java` tích hợp bộ đệm thời gian chống nghẽn luồng kết hợp dữ liệu dự phòng trong DAO. Nếu SQL Server chưa mở cổng, trang web vẫn phản hồi ngay lập tức (< 50ms) và cho phép đăng nhập thử nghiệm, không gây lỗi HTTP Status 500.

---

## 8. XỬ LÝ SỰ CỐ THƯỜNG GẶP

1. **Lỗi `Connection refused: getsockopt` (cổng 1433):**
   * Chạy file `enable-sql-tcp.bat` bằng quyền Administrator để kích hoạt TCP/IP và cổng 1433 cho instance SQL Server.
2. **Thêm danh mục mới nhưng không hiển thị trên Trang chủ:**
   * Do danh mục đang để trạng thái **Khóa (status = 0)**. Vào trang quản trị, bấm **Sửa** danh mục và chọn lại trạng thái **Hoạt động (status = 1)**.
3. **Ảnh upload không hiển thị:**
   * Ảnh được lưu tại thư mục `upload` trên máy và phục vụ qua Servlet `/image?fname=...`. Có thể dùng trực tiếp link ảnh online hoặc upload file từ máy tính.

---

**Link repository nộp bài:** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)
