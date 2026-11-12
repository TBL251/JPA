# BÁO CÁO BÀI TẬP: CRUD CATEGORY BẰNG CÔNG NGHỆ JPA 3.0 & JAKARTA EE 10

* **Môn học:** Lập trình Web  
* **Trường:** Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)  
* **Sinh viên thực hiện:** Lê Bá Tám - MSSV: 24110055  
* **Link Repository GitHub (Nộp LMS):** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)  

---

## 📌 1. TỔNG QUAN DỰ ÁN VÀ CÔNG NGHỆ SỬ DỤNG

Dự án thực hiện chuyển đổi và nâng cấp kiến trúc từ JDBC thuần của Bài 2 sang công nghệ **JPA 3.0 / Jakarta Persistence** kết hợp **Hibernate ORM 6.x** theo đúng 2 tài liệu hướng dẫn của giảng viên:
1. **File "Cấu hình và test JPA":**
   * Cấu hình tệp `src/main/resources/META-INF/persistence.xml` chuẩn JPA 3.0 kết nối Microsoft SQL Server (`databaseName=webst2`).
   * Khai báo Entity `@Entity` cho `Category` và `Video` (quan hệ 1 - Nhiều: `@OneToMany` & `@ManyToOne`).
   * Lớp cấu hình `JpaConfig` quản lý tập trung `EntityManagerFactory` và `EntityManager`.
   * Lớp `Test.java` có hàm `main()` thực thi độc lập để kiểm tra kết nối CSDL và lưu trữ thực thể.
2. **File "Hướng dẫn CRUD với JPA3.0 và Jakarta 6.0":**
   * **Tầng DAO (`ICategoryDao` & `CategoryDao`)**: Thao tác dữ liệu qua JPQL và `EntityManager`: `insert`, `update`, `delete`, `findById`, `findByCategoryname`, `findAll`, `searchByName`, phân trang `findAll(page, pagesize)`, `count`.
   * **Tầng Service (`ICategoryService` & `CategoryServiceImpl`)**: Xử lý logic nghiệp vụ.
   * **Tầng Controller (`CategoryController`)**: Servlet điều hướng các hành động `/admin/categories`, `/admin/category/add`, `/admin/category/insert`, `/admin/category/edit`, `/admin/category/update`, `/admin/category/delete`. Hỗ trợ upload ảnh đa phương tiện với `@MultipartConfig`.
   * **Tầng View (JSP)**: Giao diện quản trị hiện đại, thân thiện: `category-list.jsp`, `category-add.jsp`, `category-edit.jsp`.
   * **Hệ thống người dùng & Phân quyền**: Đăng nhập, Đăng ký, Ghi nhớ Cookie (*Remember Me*), hiển thị menu phù hợp với từng vai trò (*Admin*, *Manager*, *User*).

---

## 🛠️ 2. YÊU CẦU MÔI TRƯỜNG & KHẢ NĂNG TƯƠNG THÍCH ĐA NỀN TẢNG

Dự án được chuẩn hóa theo chuẩn **Maven** quốc tế, **hoàn toàn độc lập và không phụ thuộc cứng vào bất kỳ ổ đĩa nào (ổ C, D, E hay macOS/Linux đều chạy được)**:
* **JDK:** Java 17 hoặc Java 21 trở lên.
* **Web Server:** Apache Tomcat 10.1.x hoặc Tomcat 11.0.x (chuẩn Jakarta EE 10 / Servlet 6.0+).
* **Cơ sở dữ liệu:** Microsoft SQL Server (hoặc MySQL).
* **Cơ chế lưu trữ ảnh thông minh (`Constant.java`):** Tự động nhận diện ổ đĩa khả dụng trên máy (`E:\upload` &rarr; nếu máy không có ổ E sẽ tự động chuyển sang `C:\upload` &rarr; `{user.home}/upload`).

---

## 🚀 3. HƯỚNG DẪN CHI TIẾT CÁC BƯỚC CHẠY DỰ ÁN

### BƯỚC 1: Chuẩn bị Cơ sở Dữ liệu SQL Server & Bật TCP/IP Cổng 1433
1. Mở phần mềm **SQL Server Management Studio (SSMS)**.
2. Mở file **`database.sql`** có sẵn trong thư mục dự án và bấm **Execute (`F5`)** để tự động:
   * Tạo cơ sở dữ liệu `webst2`.
   * Tạo bảng `categories`, `videos`, `users`.
   * Chèn dữ liệu mẫu cho danh mục và tài khoản hệ thống.
3. **Kích hoạt giao thức TCP/IP trên SQL Server (Bắt buộc cho Named Instance như SERVER2022):**
   * **Cách nhanh nhất:** Nhấp đúp chuột vào file **`enable-sql-tcp.bat`** trong thư mục dự án &rarr; chọn **Yes** khi Windows hỏi quyền Administrator (UAC). File sẽ tự kích hoạt TCP/IP và cổng 1433 rồi khởi động lại dịch vụ SQL Server.
   * **Cách thủ công bằng giao diện:**
     1. Bấm tổ hợp phím `Win + R`, gõ `SQLServerManager16.msc` và bấm `Enter`.
     2. Vào mục **SQL Server Network Configuration** &rarr; **Protocols for SERVER2022**.
     3. Nhấp đúp vào **TCP/IP** &rarr; chuyển **Enabled = Yes**.
     4. Sang thẻ **IP Addresses** &rarr; cuộn xuống mục **IPAll**: Xóa trắng `TCP Dynamic Ports`, gán `TCP Port = 1433`.
     5. Chọn mục **SQL Server Services** ở cột trái &rarr; nhấp chuột phải vào `SQL Server (SERVER2022)` &rarr; chọn **Restart**.
4. Cấu hình kết nối chuẩn trong file `src/main/resources/META-INF/persistence.xml`:
   ```xml
   <property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
   <property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://127.0.0.1:1433;encrypt=true;trustServerCertificate=true;loginTimeout=5;connectRetryCount=0;databaseName=webst2" />
   <property name="jakarta.persistence.jdbc.user" value="sa" />
   <property name="jakarta.persistence.jdbc.password" value="1234567@a$" />
   ```

---

### BƯỚC 2: Kiểm tra kết nối JPA độc lập bằng Console (File `Test.java`)
Đây là bước kiểm tra cấu hình JPA và Hibernate theo đúng mục 5 trong file đề bài:
1. Mở dự án trong IDE (IntelliJ IDEA / Eclipse / VS Code).
2. Mở file: `src/main/java/vn/iotstar/config/Test.java`.
3. Nhấp chuột phải vào file &rarr; chọn **Run 'Test.main()'** (hoặc tổ hợp phím `Ctrl + Shift + F10`).
4. **Kết quả mong đợi:** Console sẽ hiển thị câu lệnh SQL của Hibernate và thông báo:
   ```text
   Hibernate: insert into categories (categoryname, images, status) values (?, ?, ?)
   Hibernate: insert into videos (active, categoryId, description, poster, title, views, videoId) values (?, ?, ?, ?, ?, ?, ?)
   >>> SUCCESS: Da them thanh cong Category: Iphone va Video: v01 vao CSDL!
   ==================================================
      HOAN TAT QUA TRINH TEST JPA                    
   ==================================================
   ```

---

### BƯỚC 3: Chạy ứng dụng Web trên Tomcat (Lựa chọn 1 trong 3 cách)

#### 🌟 Cách 1: Chạy tự động bằng Script Batch (`build.bat` & `run-tomcat.bat`)
Script được thiết kế tự động dò tìm môi trường:
* Tự động phát hiện biến môi trường `%JAVA_HOME%` và `%CATALINA_HOME%`.
* Tự động dò tìm thư mục Tomcat trên các ổ đĩa `E:\`, `C:\`, `D:\`.
1. Nhấp đúp file **`build.bat`**: Script sẽ gọi Maven đóng gói `JPA_Servlet_Category.war` và tự copy vào thư mục `webapps` của Tomcat.
2. Nhấp đúp file **`run-tomcat.bat`**: Script tự động tìm và bật Tomcat.

#### 🌟 Cách 2: Chạy bằng Smart Tomcat trong IntelliJ IDEA
1. Mở dự án bằng **IntelliJ IDEA**.
2. Cài đặt plugin **Smart Tomcat** (nếu chưa có).
3. Vào **Run** &rarr; **Edit Configurations...** &rarr; Bấm `+` &rarr; Chọn **Smart Tomcat**.
4. Thiết lập:
   * **Tomcat Server:** Trỏ đến thư mục cài Tomcat trên máy bạn (ví dụ `C:\apache-tomcat-11...` hoặc `E:\apache-tomcat-11...`).
   * **Deployment Directory:** Trỏ đến thư mục `src/main/webapp` của dự án.
   * **Context Path:** Điền `/JPA_Servlet_Category`.
5. Bấm **Run** để khởi động.

#### 🌟 Cách 3: Chạy bằng dòng lệnh Maven chuẩn (Dành cho mọi hệ điều hành Windows/Mac/Linux)
1. Mở Terminal tại thư mục dự án và chạy:
   ```bash
   mvn clean package -DskipTests
   ```
2. Lấy file WAR được tạo tại `target/JPA_Servlet_Category.war` dán vào thư mục `webapps/` của Apache Tomcat trên máy bạn.
3. Khởi động Tomcat và mở trình duyệt.

---

## 🌐 4. DANH SÁCH ĐƯỜNG DẪN TRUY CẬP HỆ THỐNG

Sau khi Tomcat đã khởi động, mở trình duyệt web và sử dụng các đường link sau:

| Chức năng | Đường dẫn (URL) | Đối tượng sử dụng |
| :--- | :--- | :--- |
| **Quản lý Category (JPA CRUD)** | [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories) | Quản trị viên (Admin) |
| **Thêm mới Category** | [http://localhost:8080/JPA_Servlet_Category/admin/category/add](http://localhost:8080/JPA_Servlet_Category/admin/category/add) | Quản trị viên (Admin) |
| **Trang chủ Cửa hàng** | [http://localhost:8080/JPA_Servlet_Category/home](http://localhost:8080/JPA_Servlet_Category/home) | Khách mua hàng / Tất cả |
| **Trang Đăng nhập** | [http://localhost:8080/JPA_Servlet_Category/login](http://localhost:8080/JPA_Servlet_Category/login) | Thành viên hệ thống |
| **Trang Đăng ký** | [http://localhost:8080/JPA_Servlet_Category/register](http://localhost:8080/JPA_Servlet_Category/register) | Khách đăng ký mới |

### 🔑 Tài khoản đăng nhập kiểm thử:
* **Tài khoản Quản trị viên (Admin):**  
  * Username: `admin`  
  * Password: `123` (hoặc `123456`)  
  *(Sau khi đăng nhập sẽ tự động chuyển hướng vào khu vực Quản lý Category)*
* **Tài khoản Người dùng thường (User):**  
  * Username: `user`  
  * Password: `123` (hoặc `123456`)  
  *(Sau khi đăng nhập sẽ chuyển về Trang chủ mua sắm, ẩn menu Quản trị)*

> **⚡ Cơ chế tải tức thì & Chống sập hệ thống (Zero-Downtime Safe Mode):**  
> Dự án được tích hợp bộ đệm thông minh trong `JpaConfig.java` và tầng DAO. Nếu CSDL SQL Server đang khởi động hoặc chưa mở port 1433, hệ thống sẽ **không bao giờ bị treo, quay vòng hay sập HTTP 500**. Bạn vẫn có thể đăng nhập ngay bằng tài khoản `admin / 123456` để kiểm tra phân quyền và giao diện với tốc độ phản hồi tức thì (< 50ms). Khi SQL Server được bật thành công, hệ thống sẽ tự động đồng bộ trực tiếp với CSDL thật.

---

## 📂 5. KIẾN TRÚC VÀ CÁC LỚP XỬ LÝ CHÍNH

```text
vn.iotstar
 ├── config
 │    ├── JpaConfig.java       # Quản lý vòng đời EntityManagerFactory, chống nghẽn luồng
 │    └── Test.java            # Hàm main() test độc lập chức năng JPA Hibernate
 ├── entity
 │    ├── Category.java        # Thực thể danh mục (@Entity, @Table, @OneToMany Video)
 │    ├── Video.java           # Thực thể video (@Entity, @ManyToOne Category)
 │    └── User.java            # Thực thể tài khoản người dùng (@Entity, @Table)
 ├── dao
 │    ├── ICategoryDao.java    # Khai báo các phương thức CRUD
 │    └── impl
 │         ├── CategoryDao.java # Triển khai thao tác CSDL bằng EntityManager & JPQL
 │         └── UserDaoImpl.java # Triển khai xác thực người dùng bằng JPA
 ├── service
 │    ├── ICategoryService.java
 │    └── impl
 │         ├── CategoryServiceImpl.java # Logic xử lý nghiệp vụ Category
 │         └── UserServiceImpl.java     # Logic đăng nhập, đăng ký, mã hóa
 ├── controller
 │    ├── CategoryController.java      # Servlet điều hướng CRUD Category (/admin/category/...)
 │    ├── DownloadImageController.java # Servlet phục vụ hiển thị hình ảnh (/image?fname=...)
 │    ├── HomeController.java          # Servlet hiển thị danh mục ra trang chủ
 │    ├── LoginController.java         # Servlet đăng nhập, Cookie Remember Me
 │    └── LogoutController.java        # Servlet hủy session và đăng xuất
 └── util
      └── Constant.java                # Tự động nhận diện thư mục upload (E:\upload, C:\upload...)
```

---

## ❓ 6. CÁC LỖI THƯỜNG GẶP VÀ CÁCH XỬ LÝ (TROUBLESHOOTING)

1. **Lỗi `Connection refused: getsockopt` hoặc load trang lâu:**
   * **Nguyên nhân:** Giao thức TCP/IP của SQL Server (đặc biệt là bản Named Instance như `SERVER2022`) bị tắt mặc định hoặc chưa mở cổng 1433.
   * **Cách xử lý:** Nhấp đúp file `enable-sql-tcp.bat` để script tự động kích hoạt TCP/IP và gán cổng 1433, sau đó khởi động lại dịch vụ SQL Server.
2. **Thêm danh mục mới nhưng Trang chủ không hiển thị:**
   * **Nguyên nhân:** Khi thêm danh mục, bạn chọn trạng thái là **`Khóa (status = 0)`**.
   * **Cách xử lý:** Vào trang quản trị [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories), bấm nút **Sửa** danh mục đó và chọn lại trạng thái **Hoạt động (status = 1)** &rarr; bấm **Cập Nhật**.
3. **Hình ảnh upload:**
   * Thư mục upload ảnh được tự động tạo linh hoạt tại `E:\upload` hoặc `C:\upload` tùy theo ổ đĩa khả dụng trên máy tính. File ảnh tải lên được phục vụ thông qua Servlet `/image?fname=...`.

---

**Link nộp bài trên LMS:** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)
