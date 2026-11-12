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

-- 3. Tao bang videos
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
        CONSTRAINT FK_Videos_Categories FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE CASCADE
    );
END
GO

-- 4. Tao bang users
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
        createddate DATE NULL
    );
END
GO

-- 5. Them du lieu mau
INSERT INTO categories (categoryname, images, status) 
VALUES 
(N'Điện thoại thông minh', N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300', 1),
(N'Laptop & Máy tính xách tay', N'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300', 1),
(N'Phụ kiện công nghệ', N'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300', 1);

INSERT INTO users (username, password, fullname, email, roleid, createddate) 
VALUES 
('admin', '123', N'Quản trị viên', 'admin@ute.udn.vn', 1, GETDATE()),
('manager', '123', N'Quản lý', 'manager@ute.udn.vn', 2, GETDATE()),
('user', '123', N'Người dùng thường', 'user@ute.udn.vn', 3, GETDATE());
GO

