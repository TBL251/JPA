# BÀI TẬP: CRUD CATEGORY BẰNG JPA 3.0 & JAKARTA EE 10 (HIBERNATE ORM)

> **Môn học:** Lập trình Web  
> **Trường:** Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)  
> **Sinh viên thực hiện:** Lê Bá Tám - MSSV: 24110055  
> **Repository GitHub:** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)

---

## 1. MỤC TIÊU VÀ NỘI DUNG THỰC HIỆN

Thực hiện chuyển đổi toàn bộ kiến trúc kết nối CSDL từ JDBC thuần của Bài 2 sang công nghệ **JPA 3.0 / Jakarta Persistence** kết hợp **Hibernate ORM 6.x** theo đúng hai tài liệu hướng dẫn:
1. **Cấu hình và test JPA:**
   - Cấu hình file `persistence.xml` (JPA 3.0 standard với persistence unit `jpa-hibernate-mysql` kết nối Microsoft SQL Server Database `webst2`).
   - Xây dựng Entity `Category` và Entity `Video` với các Annotation chuẩn JPA (`@Entity`, `@Table`, `@Id`, `@GeneratedValue`, `@Column`, `@NamedQuery`, `@OneToMany`, `@ManyToOne`, `@JoinColumn`).
   - Xây dựng lớp cấu hình `JpaConfig` quản lý `EntityManagerFactory` và `EntityManager`.
   - Lớp thực thi độc lập `Test.java` kiểm tra việc thêm mới Category và Video vào CSDL.
2. **Hướng dẫn CRUD với JPA 3.0 và Jakarta 6.0:**
   - Tầng DAO: `ICategoryDao` và `CategoryDao` triển khai đầy đủ các phương thức `insert`, `update`, `delete`, `findById`, `findByCategoryname`, `findAll`, `searchByName`, phân trang `findAll(page, pagesize)`, `count`.
   - Tầng Service: `ICategoryService` và `CategoryServiceImpl`.
   - Tầng Controller: `CategoryController` (`@MultipartConfig`, `@WebServlet`) quản lý các luồng `/admin/categories`, `/admin/category/add`, `/admin/category/insert`, `/admin/category/edit`, `/admin/category/update`, `/admin/category/delete`.
   - Tầng View: Các trang JSP giao diện đẹp, hiện đại: `category-list.jsp`, `category-add.jsp`, `category-edit.jsp`.
   - Xử lý tải và hiển thị ảnh đa phương tiện (hỗ trợ cả URL trực tiếp và tải file từ máy tính qua Controller `/image?fname=...`).
   - Tích hợp hệ thống Authentication (Đăng nhập, Đăng ký, Ghi nhớ Remember Me qua Cookie & Session) hoàn thiện từ Bài 2.

---

## 2. CẤU TRÚC THƯ MỤC DỰ ÁN

```text
E:\WEb\JPA
├── pom.xml                                      # Quản lý thư viện Maven (JPA 3.0, Hibernate 6.x, MSSQL, Servlet 6.1)
├── build.bat                                    # Script build Maven đóng gói WAR và copy vào Tomcat 11
├── run-tomcat.bat                               # Script khởi động Apache Tomcat 11
├── database.sql                                 # Script tạo CSDL webst2 và dữ liệu mẫu
├── README.md                                    # Hướng dẫn chi tiết dự án
├── src
│   ├── main
│   │   ├── java
│   │   │   └── vn
│   │   │       └── iotstar
│   │   │           ├── config
│   │   │           │   ├── JpaConfig.java       # Khởi tạo EntityManagerFactory & EntityManager
│   │   │           │   ├── JPAConfig.java       # Alias tương thích
│   │   │           │   └── Test.java            # File main() chạy test độc lập JPA theo đề bài
│   │   │           ├── controller
│   │   │           │   ├── CategoryController.java      # Servlet điều hướng CRUD Category
│   │   │           │   ├── DownloadImageController.java # Servlet phục vụ hiển thị ảnh (/image?fname=...)
│   │   │           │   ├── HomeController.java          # Trang chủ hiển thị danh mục
│   │   │           │   ├── LoginController.java         # Xử lý đăng nhập, Cookie Remember Me
│   │   │           │   ├── LogoutController.java        # Xử lý đăng xuất
│   │   │           │   ├── RegisterController.java      # Xử lý đăng ký thành viên
│   │   │           │   └── WaitingController.java       # Phân quyền sau đăng nhập
│   │   │           ├── dao
│   │   │           │   ├── ICategoryDao.java            # Interface DAO Category
│   │   │           │   ├── CategoryDao.java             # Lớp tương thích
│   │   │           │   ├── UserDao.java                 # Interface DAO User
│   │   │           │   └── impl
│   │   │           │       ├── CategoryDao.java         # Triển khai CRUD Category bằng JPQL & EntityManager
│   │   │           │       └── UserDaoImpl.java         # Triển khai DAO User bằng JPA
│   │   │           ├── entity
│   │   │           │   ├── Category.java                # Entity Category (@OneToMany Video)
│   │   │           │   ├── Video.java                   # Entity Video (@ManyToOne Category)
│   │   │           │   └── User.java                    # Entity User
│   │   │           ├── service
│   │   │           │   ├── ICategoryService.java        # Interface Service Category
│   │   │           │   ├── UserService.java             # Interface Service User
│   │   │           │   └── impl
│   │   │           │       ├── CategoryServiceImpl.java # Xử lý logic nghiệp vụ Category
│   │   │           │       └── UserServiceImpl.java     # Xử lý logic nghiệp vụ User
│   │   │           └── util
│   │   │               └── Constant.java                # Hằng số cấu hình (thư mục upload E:\upload, Cookie...)
│   │   ├── resources
│   │   │   └── META-INF
│   │   │       └── persistence.xml              # Cấu hình kết nối CSDL và Hibernate
│   │   └── webapp
│   │       ├── WEB-INF
│   │       │   └── web.xml                      # Cấu hình Web Application Jakarta EE 6.1
│   │       └── views
│   │           ├── home.jsp                     # Giao diện Trang chủ
│   │           ├── login.jsp                    # Giao diện Đăng nhập
│   │           ├── register.jsp                 # Giao diện Đăng ký
│   │           └── admin
│   │               ├── category-list.jsp        # Danh sách Category, bảng hiển thị ảnh, nút sửa/xóa
│   │               ├── category-add.jsp         # Form thêm mới Category (upload ảnh + nhập link)
│   │               └── category-edit.jsp        # Form cập nhật Category (xem trước ảnh cũ)
```

---

## 3. CẤU HÌNH PERSISTENCE.XML VÀ CSDL

Tệp `src/main/resources/META-INF/persistence.xml` được thiết lập chuẩn JPA 3.0:

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
            <!-- Cấu hình JDBC SQL Server -->
            <property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
            <property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://localhost:1433;encrypt=true;trustServerCertificate=true;databaseName=webst2" />
            <property name="jakarta.persistence.jdbc.user" value="sa" />
            <property name="jakarta.persistence.jdbc.password" value="1234567@a$" />
            
            <!-- Cấu hình Hibernate -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.SQLServerDialect" />
            <property name="hibernate.show_sql" value="true" />
            <property name="hibernate.format_sql" value="true" />
            <property name="hibernate.hbm2ddl.auto" value="update" />
        </properties>
    </persistence-unit>
</persistence>
```

---

## 4. HƯỚNG DẪN BUILD VÀ CHẠY DỰ ÁN

### Cách 1: Chạy trực tiếp qua Script tự động
1. **Build mã nguồn:** Nhấp đúp vào file `build.bat`. Script sẽ tự động chạy Maven để build file `JPA_Servlet_Category.war` và sao chép trực tiếp vào thư mục `E:\apache-tomcat-11.0.27\webapps\`.
2. **Khởi động Tomcat:** Nhấp đúp vào file `run-tomcat.bat`.
3. **Mở trình duyệt:**
   - Quản lý Category: [http://localhost:8080/JPA_Servlet_Category/admin/categories](http://localhost:8080/JPA_Servlet_Category/admin/categories)
   - Trang chủ: [http://localhost:8080/JPA_Servlet_Category/home](http://localhost:8080/JPA_Servlet_Category/home)
   - Đăng nhập: [http://localhost:8080/JPA_Servlet_Category/login](http://localhost:8080/JPA_Servlet_Category/login)

### Cách 2: Chạy kiểm tra JPA độc lập (Console Test)
Mở lớp `vn.iotstar.config.Test` và chạy hàm `main()` để kiểm tra kết nối CSDL và thao tác `persist` đối tượng Category và Video.

---

## 5. NỘP BÀI TẬP
- **Link Repository GitHub:** [https://github.com/TBL251/JPA.git](https://github.com/TBL251/JPA.git)
