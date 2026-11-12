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

## 🛠️ 2. YÊU CẦU MÔI TRƯỜNG

* **Hệ điều hành:** Windows 10/11
* **Java Development Kit (JDK):** JDK 17 hoặc JDK 21 (được tích hợp sẵn trong IntelliJ IDEA hoặc cài đặt độc lập)
* **Web Server:** Apache Tomcat 11.0.x (hỗ trợ Jakarta EE 10 / Servlet 6.1)
* **Hệ quản trị CSDL:** Microsoft SQL Server 2016/2019/2022
* **Công cụ build:** Apache Maven 3.8+ (đã tích hợp trong IntelliJ IDEA)

---

## 🚀 3. HƯỚNG DẪN CHI TIẾT CÁC BƯỚC CHẠY DỰ ÁN

### BƯỚC 1: Chuẩn bị Cơ sở Dữ liệu SQL Server
1. Mở phần mềm **SQL Server Management Studio (SSMS)**.
2. Mở file **`database.sql`** có sẵn trong thư mục gốc của dự án (`E:\WEb\JPA\database.sql`).
3. Bấm **Execute (`F5`)** để tự động:
   * Tạo cơ sở dữ liệu `webst2`.
   * Tạo bảng `categories`, `videos`, `users`.
   * Chèn dữ liệu mẫu cho danh mục và các tài khoản hệ thống.
4. Kiểm tra thông tin kết nối trong file `src/main/resources/META-INF/persistence.xml`:
   ```xml
   <property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
   <property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://127.0.0.1:63755;encrypt=true;trustServerCertificate=true;loginTimeout=5;connectRetryCount=0;databaseName=webst2" />
   <property name="jakarta.persistence.jdbc.user" value="sa" />
   <property name="jakarta.persistence.jdbc.password" value="1234567@a$" />
   ```
   > **Lưu ý về cổng kết nối (Port):**
   > * Nếu SQL Server của bạn là bản mặc định (*Default Instance*), hãy đổi cổng thành `1433`.
   > * Nếu SQL Server là bản đặt tên (*Named Instance*, ví dụ `SERVER2022`), hãy điền cổng tương ứng trên máy bạn (máy tính hiện tại đang dùng cổng `63755`).
   > * Mật khẩu tài khoản `sa` mặc định là `1234567@a$`.

---

### BƯỚC 2: Kiểm tra kết nối JPA độc lập bằng Console (File `Test.java`)
Đây là bước kiểm tra cấu hình JPA và Hibernate theo đúng mục 5 trong file đề bài:
1. Mở dự án trong IDE (IntelliJ IDEA / Eclipse / Antigravity IDE).
2. Điều hướng đến file: `src/main/java/vn/iotstar/config/Test.java`.
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

### BƯỚC 3: Chạy ứng dụng Web trên Apache Tomcat 11

#### 👉 Cách A: Chạy tự động bằng Script Batch (Khuyên dùng)
Dự án đã được tích hợp sẵn 2 file script tự động hóa:
1. **Đóng gói file WAR:**
   * Nhấp đúp chuột vào file **`build.bat`**.
   * Script sẽ tự động gọi Maven biên dịch 22 file mã nguồn, đóng gói thành tệp `target\JPA_Servlet_Category.war` và tự động sao chép sang thư mục `E:\apache-tomcat-11.0.27\webapps\`.
2. **Khởi động Apache Tomcat:**
   * Nhấp đúp chuột vào file **`run-tomcat.bat`**.
   * Cửa sổ Tomcat sẽ xuất hiện và load ứng dụng trong khoảng vài giây.
3. **Mở trình duyệt web:**
   * Truy cập các đường dẫn được liệt kê ở mục 4 bên dưới.

#### 👉 Cách B: Chạy qua giao diện IntelliJ IDEA (Smart Tomcat)
1. Trong IntelliJ, vào **Run** &rarr; **Edit Configurations...** &rarr; Bấm dấu `+` &rarr; Chọn **Smart Tomcat**.
2. Thiết lập các thông số:
   * **Tomcat Server:** Chọn thư mục `E:\apache-tomcat-11.0.27`.
   * **Deployment Directory:** Chọn thư mục `E:\WEb\JPA\src\main\webapp`.
   * **Context Path:** Điền `/JPA_Servlet_Category`.
3. Bấm **Apply** &rarr; **Run**.

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
  * Password: `123`  
  *(Sau khi đăng nhập sẽ tự động chuyển hướng vào khu vực Quản lý Category)*
* **Tài khoản Người dùng thường (User):**  
  * Username: `user`  
  * Password: `123`  
  *(Sau khi đăng nhập sẽ chuyển về Trang chủ mua sắm, không thấy menu Quản trị)*

---

## 📂 5. KIẾN TRÚC VÀ CÁC LỚP XỬ LÝ CHÍNH

```text
vn.iotstar
 ├── config
 │    ├── JpaConfig.java       # Quản lý vòng đời EntityManagerFactory và tạo EntityManager
 │    └── Test.java            # Hàm main() test độc lập chức năng JPA Hibernate
 ├── entity
 │    ├── Category.java        # Thực thể danh mục (@Entity, @Table, @OneToMany Video)
 │    ├── Video.java           # Thực thể video (@Entity, @ManyToOne Category)
 │    └── User.java            # Thực thể tài khoản người dùng
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
      └── Constant.java                # Hằng số hệ thống (thư mục upload E:\upload, Cookie...)
```

---

## ❓ 6. CÁC LỖI THƯỜNG GẶP VÀ CÁCH XỬ LÝ (TROUBLESHOOTING)

1. **Lỗi `Connection refused: getsockopt` hoặc load trang rất lâu:**
   * **Nguyên nhân:** Cổng kết nối trong `persistence.xml` không đúng với cổng SQL Server đang mở, hoặc SQL Server chưa được bật.
   * **Cách xử lý:** Mở dịch vụ `SQL Server (SERVER2022)` trong Windows Services. Kiểm tra cổng SQL Server đang lắng nghe (máy hiện tại là cổng `63755`) và đảm bảo dùng `127.0.0.1` thay vì `localhost` để tránh hiện tượng chờ IPv6.
2. **Thêm danh mục mới nhưng Trang chủ không hiển thị:**
   * **Nguyên nhân:** Khi thêm danh mục, bạn chọn trạng thái là **`Khóa (status = 0)`**.
   * **Cách xử lý:** Vào trang quản trị [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories), bấm nút **Sửa** danh mục đó và chọn lại trạng thái **Hoạt động (status = 1)** &rarr; bấm **Cập Nhật**.
3. **Hình ảnh upload không hiển thị:**
   * Đảm bảo thư mục `E:\upload` tồn tại trên máy (hệ thống sẽ tự động tạo thư mục này khi chạy). File ảnh tải lên được phục vụ qua Servlet `/image?fname=...`.

---

**Link nộp bài trên LMS:** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)
