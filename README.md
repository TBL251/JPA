# Báo cáo bài tập: Chuyển đổi Bài tập 01 sang JPA 3.0 và Jakarta EE 10
## Hệ thống quản lý danh mục sản phẩm (CRUD Category) và phân quyền người dùng

---

### Thông tin chung
* Trường: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)
* Khoa: Công nghệ Thông tin
* Bộ môn: Kỹ thuật Phần mềm / Công nghệ Web
* Môn học: Lập trình Web
* Sinh viên thực hiện: Lê Bá Tám
* Mã số sinh viên (MSSV): 24110055
* Đường dẫn repository GitHub: [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)

---

## Mục lục
1. [Giới thiệu và mục tiêu đề bài](#1-giới-thiệu-và-mục-tiêu-đề-bài)
2. [Công nghệ sử dụng](#2-công-nghệ-sử-dụng)
3. [Kiến trúc hệ thống và cấu trúc mã nguồn](#3-kiến-trúc-hệ-thống-và-cấu-trúc-mã-nguồn)
4. [Mô hình thực thể dữ liệu](#4-mô-hình-thực-thể-dữ-liệu)
5. [Chi tiết tầng xử lý dữ liệu](#5-chi-tiết-tầng-xử-lý-dữ-liệu)
6. [Hướng dẫn thiết lập cơ sở dữ liệu SQL Server](#6-hướng-dẫn-thiết-lập-cơ-sở-dữ-liệu-sql-server)
7. [Kiểm thử kết nối JPA độc lập (Test.java)](#7-kiểm-thử-kết-nối-jpa-độc-lập-testjava)
8. [Hướng dẫn khởi động ứng dụng trên Tomcat](#8-hướng-dẫn-khởi-động-ứng-dụng-trên-tomcat)
9. [Bảng điều hướng URL và tài khoản kiểm thử](#9-bảng-điều-hướng-url-và-tài-khoản-kiểm-thử)
10. [Cơ chế xử lý timeout và dữ liệu dự phòng](#10-cơ-chế-xử-lý-timeout-và-dữ-liệu-dự-phòng)
11. [Hướng dẫn xử lý sự cố thường gặp](#11-hướng-dẫn-xử-lý-sự-cố-thường-gặp)

---

## 1. Giới thiệu và mục tiêu đề bài

Dự án chuyển đổi ứng dụng web từ JDBC thuần (Bài tập 01) sang JPA 3.0 (Jakarta Persistence), sử dụng Hibernate ORM 6.x trên nền tảng Jakarta EE 10.

Các nội dung được triển khai theo hai tài liệu hướng dẫn:

### A. Yêu cầu tài liệu "Cấu hình và test JPA":
* Khai báo dependency trong `pom.xml`: Hibernate ORM Core 6.x, Jakarta Persistence API 3.x, Microsoft SQL Server JDBC Driver.
* Cấu hình tệp `META-INF/persistence.xml` chuẩn JPA 3.0 kết nối cơ sở dữ liệu `webst2` trên SQL Server.
* Định nghĩa Entity `Category` và `Video` với các chú thích JPA: `@Entity`, `@Table`, `@Id`, `@GeneratedValue`, `@Column`, `@NamedQuery`.
* Thiết lập quan hệ 1-Nhiều (một Category có nhiều Video) với `@OneToMany(mappedBy = "category")` và `@ManyToOne` kèm `@JoinColumn(name = "categoryId")`.
* Xây dựng lớp `JpaConfig.java` quản lý `EntityManagerFactory` theo mô hình Singleton.
* Xây dựng chương trình `Test.java` có hàm `main()` để kiểm thử độc lập: mở Transaction, cập nhật cấu trúc bảng (`hbm2ddl.auto=update`), chèn bản ghi mẫu cho Category và Video rồi xác nhận giao dịch.

### B. Yêu cầu tài liệu "Hướng dẫn CRUD với JPA3.0 và Jakarta 6.0":
* Tầng DAO (`ICategoryDao` và `CategoryDao`): Thao tác qua `EntityManager` và truy vấn JPQL, cung cấp 9 phương thức CRUD:
  1. `insert(Category category)`: Thêm danh mục mới vào CSDL.
  2. `update(Category category)`: Cập nhật thông tin danh mục.
  3. `delete(int cateid)`: Xóa danh mục theo mã ID.
  4. `findById(int cateid)`: Truy vấn danh mục theo khóa chính.
  5. `findByCategoryname(String name)`: Tìm danh mục theo tên chính xác.
  6. `findAll()`: Lấy danh sách toàn bộ danh mục qua `@NamedQuery("Category.findAll")`.
  7. `searchByName(String catname)`: Tìm danh mục theo từ khóa (`LIKE %...%`).
  8. `findAll(int page, int pagesize)`: Phân trang danh mục kết hợp `setFirstResult()` và `setMaxResults()`.
  9. `count()`: Đếm tổng số danh mục (`SELECT count(c) FROM Category c`).
* Tầng Service (`ICategoryService` và `CategoryServiceImpl`): Đóng gói logic nghiệp vụ danh mục.
* Tầng Controller (`CategoryController`): Servlet điều hướng các endpoint:
  * `/admin/categories` và `/admin/category/list`: Hiển thị danh sách danh mục.
  * `/admin/category/add` và `/admin/category/insert`: Form và xử lý thêm danh mục, hỗ trợ tải file ảnh qua `@MultipartConfig`.
  * `/admin/category/edit` và `/admin/category/update`: Form và xử lý cập nhật danh mục.
  * `/admin/category/delete`: Xóa danh mục.
* Giao diện (JSP): Các trang quản trị `category-list.jsp`, `category-add.jsp`, `category-edit.jsp`.

### C. Chuyển đổi các chức năng từ Bài tập 01 sang JPA 3.0:
* Quản lý người dùng: Chuyển đổi bảng `users` sang Entity `User.java`, xây dựng DAO `UserDaoImpl.java` và Service `UserServiceImpl.java` thao tác qua `EntityManager`.
* Đăng nhập và đăng ký: Xác thực tài khoản, đăng ký thành viên mới, mã hóa mật khẩu, ghi nhớ phiên đăng nhập bằng Cookie.
* Phân quyền người dùng:
  * Quản trị viên (`roleid = 1`): Chuyển hướng qua servlet `/waiting` vào trang quản trị danh mục (`/admin/categories`).
  * Người dùng thường (`roleid = 2` hoặc `3`): Chuyển hướng về trang chủ (`/home`), không hiển thị liên kết quản trị.
* Phục vụ hình ảnh (`DownloadImageController`): Servlet trả về ảnh qua endpoint `/image?fname=...`, hỗ trợ ảnh lưu cục bộ và ảnh liên kết từ internet.

---

## 2. Công nghệ sử dụng

Dự án quản lý thư viện và vòng đời bản dựng bằng Maven:

* Ngôn ngữ: Java 17 LTS hoặc Java 21 LTS.
* Nền tảng web: Jakarta EE 10 (Jakarta Servlet 6.1, Jakarta JSP 4.0, Jakarta JSTL 3.0).
* Máy chủ web: Apache Tomcat 10.1.x hoặc 11.0.x.
* JPA Provider: Hibernate ORM 6.5.2.Final, Jakarta Persistence API 3.1.0, Hibernate Validator 8.0.
* Hệ quản trị cơ sở dữ liệu: Microsoft SQL Server (tương thích các phiên bản 2016, 2019, 2022).
* Trình điều khiển JDBC: Microsoft JDBC Driver for SQL Server 12.6.1 (`mssql-jdbc`).
* Thư viện tiện ích: Apache Commons-IO 2.16.1 hỗ trợ xử lý luồng dữ liệu file.
* Đường dẫn lưu trữ ảnh (`Constant.java`): Tự động kiểm tra và sử dụng thư mục theo thứ tự: `E:\upload`, `C:\upload` hoặc `{user.home}/upload`.

---

## 3. Kiến trúc hệ thống và cấu trúc mã nguồn

Dự án tổ chức theo mô hình MVC kết hợp Service và DAO:

```text
E:\WEb\JPA
├── pom.xml                                    # File cấu hình thư viện Maven chuẩn Jakarta EE 10
├── database.sql                               # Script SQL tạo CSDL webst2 và bảng dữ liệu mẫu
├── build.bat                                  # Script biên dịch và sao chép file WAR vào Tomcat
├── run-tomcat.bat                             # Script tìm kiếm và khởi động Apache Tomcat
├── enable-sql-tcp.bat                         # Script cấu hình TCP/IP cổng 1433 cho SQL Server
├── push-github.bat                            # Script đồng bộ mã nguồn lên GitHub
├── README.md                                  # Báo cáo kỹ thuật dự án
│
├── src\main\resources
│   └── META-INF
│       └── persistence.xml                    # Cấu hình Persistence Unit chuẩn JPA 3.0
│
├── src\main\java\vn\iotstar
│   ├── config
│   │   ├── JpaConfig.java                     # Khởi tạo EntityManagerFactory và xử lý timeout
│   │   └── Test.java                          # Kiểm thử kết nối JPA và Hibernate bằng hàm main()
│   │
│   ├── entity
│   │   ├── Category.java                      # Entity danh mục (@OneToMany Video)
│   │   ├── Video.java                         # Entity video (@ManyToOne Category)
│   │   └── User.java                          # Entity tài khoản người dùng
│   │
│   ├── dao
│   │   ├── ICategoryDao.java                  # Interface khai báo 9 phương thức CRUD Category
│   │   ├── UserDao.java                       # Interface xác thực tài khoản
│   │   └── impl
│   │       ├── CategoryDao.java               # Triển khai CRUD Category qua EntityManager
│   │       └── UserDaoImpl.java               # Triển khai xác thực tài khoản qua JPA
│   │
│   ├── service
│   │   ├── ICategoryService.java
│   │   ├── UserService.java
│   │   └── impl
│   │       ├── CategoryServiceImpl.java       # Xử lý logic nghiệp vụ Category
│   │       └── UserServiceImpl.java           # Xử lý xác thực, đăng ký và mật khẩu
│   │
│   ├── controller
│   │   ├── CategoryController.java            # Servlet CRUD Category (/admin/category/...)
│   │   ├── DownloadImageController.java       # Servlet phục vụ file ảnh (/image?fname=...)
│   │   ├── HomeController.java                # Servlet hiển thị danh mục ra trang chủ (/home)
│   │   ├── LoginController.java               # Servlet đăng nhập và ghi nhớ phiên (/login)
│   │   ├── RegisterController.java            # Servlet đăng ký tài khoản (/register)
│   │   ├── LogoutController.java              # Servlet kết thúc phiên làm việc (/logout)
│   │   └── WaitingController.java             # Servlet điều hướng phân quyền (/waiting)
│   │
│   └── util
│       └── Constant.java                      # Khai báo đường dẫn và định vị thư mục upload
│
└── src\main\webapp
    ├── WEB-INF
    │   └── web.xml                            # Cấu hình servlet theo chuẩn Servlet 6.1
    └── views
        ├── home.jsp                           # Trang chủ hiển thị danh mục
        ├── login.jsp                          # Trang đăng nhập
        ├── register.jsp                       # Trang đăng ký
        └── admin
            ├── category-list.jsp              # Bảng danh sách danh mục
            ├── category-add.jsp               # Form thêm danh mục
            └── category-edit.jsp              # Form chỉnh sửa danh mục
```

---

## 4. Mô hình thực thể dữ liệu

### A. Thực thể `Category` ([Category.java](src/main/java/vn/iotstar/entity/Category.java))
Ánh xạ tới bảng `categories` trong CSDL:
```java
@Entity
@Table(name = "categories")
@NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c")
public class Category implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "categoryId")
    private int categoryId;

    @Column(name = "categoryname", columnDefinition = "NVARCHAR(255) NULL")
    @NotEmpty(message = "Không được phép rỗng")
    private String categoryname;

    @Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
    private String images;

    @Column(name = "status")
    private int status; // 1: Hoạt động, 0: Tạm khóa

    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL)
    private List<Video> videos = new ArrayList<>();
    // getters, setters, addVideo, removeVideo
}
```

### B. Thực thể `Video` ([Video.java](src/main/java/vn/iotstar/entity/Video.java))
Ánh xạ tới bảng `videos`, thể hiện quan hệ nhiều-1 với Category:
```java
@Entity
@Table(name = "videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {
    @Id
    @Column(name = "videoId")
    private String videoId;

    @Column(name = "title", columnDefinition = "NVARCHAR(255) NULL")
    private String title;

    @Column(name = "poster", columnDefinition = "NVARCHAR(255) NULL")
    private String poster;

    @Column(name = "views")
    private int views;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX) NULL")
    private String description;

    @Column(name = "active")
    private boolean active;

    @ManyToOne
    @JoinColumn(name = "categoryId")
    private Category category;
    // getters, setters
}
```

### C. Thực thể `User` ([User.java](src/main/java/vn/iotstar/entity/User.java))
Ánh xạ tới bảng `users` phục vụ xác thực và phân quyền:
* `id` (`INT`, khóa chính tự tăng).
* `userName` (`VARCHAR(50)`, giá trị duy nhất, không rỗng).
* `passWord` (`VARCHAR(255)`, mật khẩu lưu trữ).
* `fullName` (`NVARCHAR(100)`, họ tên người dùng).
* `email` (`NVARCHAR(150)`, địa chỉ email).
* `phone` (`VARCHAR(20)`, số điện thoại liên hệ).
* `roleid` (`INT`, phân quyền: `1` là Quản trị viên, `2` là Quản lý, `3` là Người dùng thường).
* `createdDate` (`DATE`, thời điểm tạo tài khoản).

---

## 5. Chi tiết tầng xử lý dữ liệu

Các thao tác dữ liệu được thực thi thông qua `EntityManager` và JPQL:

| Phương thức trong ICategoryDao | Cách triển khai qua JPA / JPQL | Mô tả chức năng |
| :--- | :--- | :--- |
| `insert(Category category)` | `enma.persist(category)` trong giao dịch `trans.begin()` và `commit()` | Thêm danh mục mới vào CSDL. |
| `update(Category category)` | `enma.merge(category)` trong giao dịch `trans.begin()` và `commit()` | Cập nhật thông tin danh mục. |
| `delete(int cateid)` | `enma.remove(enma.find(Category.class, cateid))` | Xóa danh mục theo ID. |
| `findById(int cateid)` | `enma.find(Category.class, cateid)` | Truy vấn danh mục theo khóa chính. |
| `findByCategoryname(String name)` | `SELECT c FROM Category c WHERE c.categoryname = :catename` | Tìm danh mục theo tên chính xác. |
| `findAll()` | `enma.createNamedQuery("Category.findAll", Category.class)` | Lấy toàn bộ danh sách danh mục. |
| `searchByName(String catname)` | `SELECT c FROM Category c WHERE c.categoryname LIKE :catname` | Tìm kiếm danh mục chứa từ khóa. |
| `findAll(int page, int pagesize)` | Query kết hợp `setFirstResult(page * pagesize)` và `setMaxResults(pagesize)` | Phân trang danh mục sản phẩm. |
| `count()` | `SELECT count(c) FROM Category c` | Đếm tổng số lượng danh mục hiện có. |

---

## 6. Hướng dẫn thiết lập cơ sở dữ liệu SQL Server

### Bước 6.1: Khởi tạo dữ liệu bằng database.sql
1. Mở SQL Server Management Studio (SSMS) và kết nối vào máy chủ SQL Server.
2. Mở file `database.sql` trong thư mục dự án `E:\WEb\JPA`.
3. Bấm phím F5 (hoặc chọn Execute) để chạy script:
   * Tạo cơ sở dữ liệu `webst2`.
   * Tạo các bảng `categories`, `videos`, `users`.
   * Chèn dữ liệu mẫu cho danh mục và tài khoản thử nghiệm.

### Bước 6.2: Cấu hình giao thức TCP/IP và cổng 1433
Áp dụng khi sử dụng SQL Server phiên bản Named Instance (như `SERVER2022`), do dịch vụ mạng mặc định có thể chưa bật TCP/IP:

Lựa chọn một trong hai cách:

#### Cách 1: Sử dụng script batch
1. Mở thư mục dự án `E:\WEb\JPA`.
2. Chạy file `enable-sql-tcp.bat` với quyền Administrator.
3. Script cấu hình Registry để kích hoạt TCP/IP trên cổng `1433` cho mục `IPAll`, sau đó khởi động lại dịch vụ SQL Server.

#### Cách 2: Cấu hình thủ công qua SQL Server Configuration Manager
1. Mở hộp thoại Run (`Win + R`), nhập `SQLServerManager16.msc` và nhấn Enter.
2. Điều hướng theo cây thư mục bên trái:
   **SQL Server Network Configuration** &rarr; **Protocols for SERVER2022** (hoặc instance tương ứng).
3. Nhấp đúp vào **TCP/IP**, chuyển giá trị **Enabled** sang **Yes**.
4. Chuyển sang tab **IP Addresses**, cuộn xuống mục **IPAll**:
   * **TCP Dynamic Ports:** Để trống.
   * **TCP Port:** Nhập giá trị `1433`.
5. Chọn **Apply** rồi chọn **OK**.
6. Chọn mục **SQL Server Services** ở danh mục bên trái, nhấp chuột phải vào dịch vụ `SQL Server (SERVER2022)` và chọn **Restart**.

### Bước 6.3: Cấu hình tệp persistence.xml
Tệp `src/main/resources/META-INF/persistence.xml` thiết lập kết nối tới cơ sở dữ liệu:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="3.0" xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence 
                                 https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd">

    <persistence-unit name="jpa-hibernate-mysql" transaction-type="RESOURCE_LOCAL">
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        
        <class>vn.iotstar.entity.Category</class>
        <class>vn.iotstar.entity.Video</class>
        <class>vn.iotstar.entity.User</class>
        
        <properties>
            <!-- Cấu hình JDBC Driver và kết nối Microsoft SQL Server cổng 1433 -->
            <property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
            <property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://127.0.0.1:1433;encrypt=true;trustServerCertificate=true;loginTimeout=5;connectRetryCount=0;databaseName=webst2" />
            <property name="jakarta.persistence.jdbc.user" value="sa" />
            <property name="jakarta.persistence.jdbc.password" value="1234567@a$" />
            
            <!-- Cấu hình Hibernate 6.x -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.SQLServerDialect" />
            <property name="hibernate.show_sql" value="true" />
            <property name="hibernate.format_sql" value="true" />
            <property name="hibernate.hbm2ddl.auto" value="update" />

            <!-- Connection Pool C3P0 -->
            <property name="hibernate.c3p0.min_size" value="5" />
            <property name="hibernate.c3p0.max_size" value="20" />
            <property name="hibernate.c3p0.timeout" value="300" />
        </properties>
    </persistence-unit>
</persistence>
```

---

## 7. Kiểm thử kết nối JPA độc lập (Test.java)

Quy trình kiểm tra hoạt động của JPA ngoài môi trường web:
1. Mở dự án trong IDE (IntelliJ IDEA, Eclipse hoặc VS Code).
2. Mở tệp `src/main/java/vn/iotstar/config/Test.java`.
3. Chạy hàm `main()` (trong IntelliJ: chọn **Run 'Test.main()'** hoặc bấm `Ctrl + Shift + F10`).
4. Kết quả ghi nhận tại Console: Hibernate thực thi lệnh tạo bảng và chèn bản ghi mẫu:
   ```text
   ==================================================
      BAT DAU KIEM TRA KET NOI VA THAO TAC VOI JPA   
   ==================================================
   Hibernate: insert into categories (categoryname, images, status) values (?, ?, ?)
   Hibernate: insert into videos (active, categoryId, description, poster, title, views, videoId) values (?, ?, ?, ?, ?, ?, ?)
   >>> SUCCESS: Da them thanh cong Category: Iphone (ID: 1) va Video: v01 vao CSDL!
   ==================================================
      HOAN TAT QUA TRINH TEST JPA                    
   ==================================================
   ```

---

## 8. Hướng dẫn khởi động ứng dụng trên Tomcat

Ứng dụng có thể triển khai theo ba cách:

### Cách 1: Sử dụng script batch
1. **Đóng gói file WAR:**
   * Chạy file `build.bat`.
   * Script gọi Maven biên dịch mã nguồn, đóng gói thành `target/JPA_Servlet_Category.war` và sao chép vào thư mục `webapps` của Tomcat.
2. **Khởi động Tomcat:**
   * Chạy file `run-tomcat.bat`.
   * Script tự động tìm đường dẫn `%CATALINA_HOME%` hoặc quét Tomcat trên các phân vùng đĩa khả dụng để khởi chạy.
3. Truy cập ứng dụng qua các URL ở mục 9.

### Cách 2: Chạy bằng plugin Smart Tomcat trong IntelliJ IDEA
1. Mở thư mục dự án trong IntelliJ IDEA.
2. Cài đặt plugin Smart Tomcat qua menu `File` &rarr; `Settings` &rarr; `Plugins`.
3. Tạo cấu hình chạy:
   * Vào menu `Run` &rarr; `Edit Configurations...`, bấm nút dấu cộng và chọn **Smart Tomcat**.
   * **Tomcat Server:** Chọn thư mục cài đặt Tomcat trên máy (ví dụ `C:\apache-tomcat-11.0.27`).
   * **Deployment Directory:** Trỏ đến thư mục `src/main/webapp`.
   * **Context Path:** Điền `/JPA_Servlet_Category`.
   * **Server Port:** `8080`.
4. Bấm **Apply** &rarr; **OK**, sau đó bấm **Run** để khởi động máy chủ.

### Cách 3: Triển khai thủ công bằng file WAR
1. Mở terminal tại thư mục gốc của dự án và chạy lệnh:
   ```bash
   mvn clean package -DskipTests
   ```
2. Sau khi bản dựng hoàn tất, sao chép file `target/JPA_Servlet_Category.war` vào thư mục `webapps/` của Apache Tomcat.
3. Chạy lệnh `bin/startup.bat` (trên Windows) hoặc `./bin/startup.sh` (trên Linux/macOS) để bật máy chủ.

---

## 9. Bảng điều hướng URL và tài khoản kiểm thử

Sau khi máy chủ khởi động, truy cập các địa chỉ tương ứng:

### Bảng điều hướng hệ thống
| Chức năng | Đường dẫn (URL) | Phương thức | Quyền truy cập | Ghi chú |
| :--- | :--- | :---: | :--- | :--- |
| Quản lý Category | [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories) | `GET` | Quản trị viên (Admin) | Danh sách danh mục, trạng thái và nút sửa/xóa. |
| Thêm mới Category | [http://localhost:8080/JPA_Servlet_Category/admin/category/add](http://localhost:8080/JPA_Servlet_Category/admin/category/add) | `GET`/`POST` | Quản trị viên (Admin) | Form thêm danh mục, hỗ trợ tải file ảnh hoặc nhập link ngoài. |
| Trang chủ | [http://localhost:8080/JPA_Servlet_Category/home](http://localhost:8080/JPA_Servlet_Category/home) | `GET` | Tất cả người dùng | Hiển thị các danh mục đang kích hoạt (status = 1). |
| Trang Đăng nhập | [http://localhost:8080/JPA_Servlet_Category/login](http://localhost:8080/JPA_Servlet_Category/login) | `GET`/`POST` | Tất cả người dùng | Xác thực tài khoản và hỗ trợ lưu cookie đăng nhập. |
| Trang Đăng ký | [http://localhost:8080/JPA_Servlet_Category/register](http://localhost:8080/JPA_Servlet_Category/register) | `GET`/`POST` | Khách vãng lai | Đăng ký tài khoản mới và kiểm tra trùng lặp email/username. |
| Đăng xuất | [http://localhost:8080/JPA_Servlet_Category/logout](http://localhost:8080/JPA_Servlet_Category/logout) | `GET` | Người dùng đã đăng nhập | Hủy session và chuyển hướng về trang đăng nhập. |

### Tài khoản kiểm thử
* **Quản trị viên (Admin):**
  * Tên đăng nhập: `admin`
  * Mật khẩu: `123` (hoặc `123456`)
  * Điều hướng sau đăng nhập: Servlet `/waiting` chuyển hướng vào khu vực quản trị `/admin/categories`.
* **Người dùng thường (User):**
  * Tên đăng nhập: `user`
  * Mật khẩu: `123` (hoặc `123456`)
  * Điều hướng sau đăng nhập: Chuyển hướng về trang chủ `/home`.

---

## 10. Cơ chế xử lý timeout và dữ liệu dự phòng

Dự án xử lý tình huống mất kết nối cơ sở dữ liệu qua hai cơ chế:

1. **Ngắt nghẽn kết nối trong [JpaConfig.java](src/main/java/vn/iotstar/config/JpaConfig.java):**
   * Sử dụng biến đếm chu kỳ kiểm tra (`RETRY_INTERVAL_MS = 15000`). Nếu kết nối CSDL chưa hoàn tất, hệ thống không lặp lại yêu cầu kết nối liên tục trên từng request HTTP, tránh tình trạng treo luồng xử lý của servlet.
2. **Dữ liệu dự phòng trong [CategoryDao.java](src/main/java/vn/iotstar/dao/impl/CategoryDao.java) và [UserDaoImpl.java](src/main/java/vn/iotstar/dao/impl/UserDaoImpl.java):**
   * Khi dịch vụ SQL Server chưa khởi động xong, hệ thống nạp danh sách dự phòng trong bộ nhớ, cho phép kiểm tra giao diện và luồng điều hướng của tài khoản `admin`. Khi CSDL kết nối thành công, DAO tự động chuyển về đọc ghi trên CSDL thật.

---

## 11. Hướng dẫn xử lý sự cố thường gặp

1. **Lỗi `Connection refused: getsockopt` hoặc không thể kết nối tới cổng 1433:**
   * *Nguyên nhân:* Giao thức TCP/IP của SQL Server chưa được bật hoặc chưa gán cổng 1433.
   * *Cách xử lý:* Chạy file `enable-sql-tcp.bat` với quyền Administrator hoặc cấu hình lại cổng 1433 cho mục `IPAll` trong SQL Server Configuration Manager.
2. **Danh mục mới tạo không hiển thị ở trang chủ:**
   * *Nguyên nhân:* Thuộc tính trạng thái của danh mục đang để giá trị `0` (khóa). Trang chủ chỉ truy vấn các bản ghi có `status = 1`.
   * *Cách xử lý:* Vào trang quản trị danh mục, chọn sửa bản ghi và cập nhật trạng thái sang `1`.
3. **Ảnh tải lên không hiển thị:**
   * *Nguyên nhân và cơ chế:* File ảnh được lưu tại thư mục upload cục bộ (`E:\upload` hoặc `C:\upload`) và phục vụ qua servlet `DownloadImageController` (`/image?fname=...`). Cần đảm bảo thư mục upload có quyền ghi và tên file trùng khớp với giá trị lưu trong CSDL.

---

Đường dẫn repository nộp bài: [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)
