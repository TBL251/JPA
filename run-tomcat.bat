@echo off
chcp 65001 >nul
set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
set "CATALINA_HOME=E:\apache-tomcat-11.0.27"

echo ========================================================
echo   KHOI DONG APACHE TOMCAT 11 CHO PROJECT JPA
echo   URL Quản lý Category: http://localhost:8080/JPA_Servlet_Category/admin/categories
echo   URL Trang chủ:        http://localhost:8080/JPA_Servlet_Category/home
echo   URL Đăng nhập:        http://localhost:8080/JPA_Servlet_Category/login
echo ========================================================
echo.

if exist "%CATALINA_HOME%\bin\startup.bat" (
    "%CATALINA_HOME%\bin\startup.bat"
) else (
    echo Khong tim thay Tomcat tai %CATALINA_HOME%
)
pause

