-- ========================================================
-- SCRIPT TAO DATABASE VA BANG CHO BAI TAP JPA 3.0 & HIBERNATE
-- Mon hoc: Lap trinh Web - HCMUTE
-- Database: webst2
-- ========================================================

-- 1. Tao Database webst2
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'webst2')
BEGIN
    CREATE DATABASE webst2;
END
GO

USE webst2;
GO

-- 2. Tao bang categories
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'categories')
BEGIN
    CREATE TABLE categories (
        categoryId INT IDENTITY(1,1) PRIMARY KEY,
        categoryname NVARCHAR(255) NULL,
        images NVARCHAR(255) NULL,
        status INT NOT NULL DEFAULT 1
    );
END
GO

-- 3. Tao bang users (Bo sung status & code OTP)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        email NVARCHAR(150) NULL,
        fullname NVARCHAR(100) NULL,
        avatar NVARCHAR(255) NULL,
        roleid INT NOT NULL DEFAULT 3, -- 1: Admin, 2: Manager, 3: User
        phone VARCHAR(20) NULL,
        status INT NOT NULL DEFAULT 1, -- 0: Chua kich hoat (cho OTP), 1: Da kich hoat
        code VARCHAR(10) NULL,         -- Ma xac thuc OTP (6 chu so)
        createddate DATE NULL
    );
END
ELSE
BEGIN
    -- Tu dong cap nhat cot status va code neu bang da ton tai
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'status')
        ALTER TABLE users ADD status INT NOT NULL DEFAULT 1;
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'code')
        ALTER TABLE users ADD code VARCHAR(10) NULL;
END
GO

-- 4. Tao bang videos (Quan he 1-n voi users va categories)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'videos')
BEGIN
    CREATE TABLE videos (
        videoId NVARCHAR(50) PRIMARY KEY,
        active BIT NOT NULL DEFAULT 1,
        description NVARCHAR(MAX) NULL,
        poster NVARCHAR(255) NULL,
        title NVARCHAR(255) NULL,
        views INT NOT NULL DEFAULT 0,
        categoryId INT NULL,
        userId INT NULL,
        CONSTRAINT FK_Videos_Categories FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE,
        CONSTRAINT FK_Videos_Users FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
    );
END
ELSE
BEGIN
    -- Tu dong cap nhat cot userId neu bang da ton tai
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('videos') AND name = 'userId')
    BEGIN
        ALTER TABLE videos ADD userId INT NULL;
        ALTER TABLE videos ADD CONSTRAINT FK_Videos_Users FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE;
    END
END
GO

-- 5. Them du lieu mau danh muc (categories)
IF NOT EXISTS (SELECT 1 FROM categories)
BEGIN
    INSERT INTO categories (categoryname, images, status) 
    VALUES 
    (N'Điện thoại & Công nghệ', N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300', 1),
    (N'Laptop & Máy tính xách tay', N'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300', 1),
    (N'Khoa học & Đời sống', N'https://images.unsplash.com/photo-1507668077129-56e32842fceb?w=300', 1),
    (N'Âm nhạc & Nghệ thuật', N'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=300', 1);
END
GO

-- 6. Them du lieu mau nguoi dung (users)
-- Mat khau '123' ma hoa BCrypt: $2a$12$R9h/cIPz0gi.URNNWB345.K8lH1q0G0b89h3g6oTz9uA0oZc7J6mK hoac ho tro fallback plaintext
IF NOT EXISTS (SELECT 1 FROM users)
BEGIN
    INSERT INTO users (username, password, fullname, email, roleid, phone, status, code, createddate) 
    VALUES 
    ('admin', '$2a$12$K8yR2u/pMvB.k5w7Y84BneNl9s9l3K1k5YxUa7y1.5A0m2u4E2Sla', N'Quản trị viên HCMUTE', 'admin@ute.udn.vn', 1, '0901234567', 1, NULL, GETDATE()),
    ('manager', '$2a$12$K8yR2u/pMvB.k5w7Y84BneNl9s9l3K1k5YxUa7y1.5A0m2u4E2Sla', N'Quản lý hệ thống', 'manager@ute.udn.vn', 2, '0902345678', 1, NULL, GETDATE()),
    ('user', '$2a$12$K8yR2u/pMvB.k5w7Y84BneNl9s9l3K1k5YxUa7y1.5A0m2u4E2Sla', N'Sinh viên HCMUTE', 'user@ute.udn.vn', 3, '0903456789', 1, NULL, GETDATE());
END
GO

-- 7. Them du lieu mau video (videos) - Dat du 12 video mau de test top 10 & phan trang 6 video/trang
IF NOT EXISTS (SELECT 1 FROM videos)
BEGIN
    DECLARE @adminId INT = (SELECT TOP 1 id FROM users WHERE username = 'admin');
    DECLARE @userId INT = (SELECT TOP 1 id FROM users WHERE username = 'user');
    DECLARE @cat1 INT = (SELECT TOP 1 categoryId FROM categories);

    INSERT INTO videos (videoId, title, description, poster, views, active, categoryId, userId)
    VALUES 
    ('v01', N'Giới thiệu Khoa CNTT - ĐH Sư phạm Kỹ thuật TP.HCM (HCMUTE)', N'Video toàn cảnh về các ngành đào tạo và hoạt động học tập nghiên cứu tại Khoa Công nghệ Thông tin.', N'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=600', 1250, 1, @cat1, @userId),
    ('v02', N'Hướng dẫn Lập trình Web Servlet & JSP chuẩn Jakarta EE', N'Bài giảng chi tiết kiến trúc MVC2 với Servlet 6.0, Jakarta Server Pages và triển khai Tomcat 11.', N'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600', 890, 1, @cat1, @userId),
    ('v03', N'Kỹ thuật kết nối CSDL Hibernate JPA 3.0 với SQL Server', N'Tìm hiểu EntityManager, Transaction, NamedQuery, Entity Mapping 1-n và CRUD chuẩn.', N'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600', 1420, 1, @cat1, @userId),
    ('v04', N'Bảo mật ứng dụng Web: Mã hóa mật khẩu BCrypt & Xác thực OTP', N'Triển khai băm mật khẩu bảo mật và gửi mã OTP qua Gmail SMTP bảo vệ tài khoản người dùng.', N'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=600', 780, 1, @cat1, @userId),
    ('v05', N'Upload file an toàn với Servlet MultipartConfig trong Jakarta EE', N'Cách xử lý upload file ảnh poster, video lưu vào thư mục hệ thống và quản lý đường dẫn.', N'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600', 650, 1, @cat1, @userId),
    ('v06', N'Phân trang dữ liệu hiệu năng cao với JPQL trong Java Web', N'Kỹ thuật phân trang 6 sản phẩm/trang bằng setFirstResult và setMaxResults của JPA.', N'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=600', 530, 1, @cat1, @userId),
    ('v07', N'Tối ưu hóa giao diện người dùng Responsive với Bootstrap & CSS3', N'Thiết kế giao diện mua sắm và xem video hiện đại, hiển thị mượt mà trên Desktop và Di động.', N'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=600', 410, 1, @cat1, @userId),
    ('v08', N'Tổng quan Kiến trúc Microservices và Container hóa Docker', N'Đóng gói ứng dụng Java Web với Docker container và triển khai trên môi trường đám mây.', N'https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=600', 920, 1, @cat1, @userId),
    ('v09', N'Giới thiệu RESTful API với Jakarta REST (JAX-RS)', N'Xây dựng các dịch vụ Web API chuẩn RESTful cho ứng dụng Mobile và Frontend Single Page App.', N'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600', 360, 1, @cat1, @userId),
    ('v10', N'Thực hành triển khai ứng dụng lên Apache Tomcat 11 Server', N'Cấu hình server.xml, context.xml, biến môi trường CATALINA_HOME và quản lý tiến trình Tomcat.', N'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600', 1100, 1, @cat1, @userId),
    ('v11', N'Phát triển ứng dụng Web thời gian thực với WebSocket API', N'Xây dựng tính năng chat trực tuyến và thông báo theo thời gian thực trong Java Web.', N'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600', 480, 1, @cat1, @userId),
    ('v12', N'Kiểm thử phần mềm và Unit Test với JUnit 5 & Mockito', N'Viết kiểm thử tự động cho tầng Service và DAO, đảm bảo độ tin cậy và chất lượng mã nguồn.', N'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=600', 670, 1, @cat1, @userId);
END
GO
