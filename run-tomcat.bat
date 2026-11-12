@echo off
set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
set "CATALINA_HOME=E:\apache-tomcat-11.0.27"

echo ========================================================
echo   DANG KHOI DONG APACHE TOMCAT 11 CHO DU AN JPA 3.0
echo   URL Category (JPA): http://localhost:8080/JPA_Servlet_Category/admin/categories
echo   URL Trang chu:      http://localhost:8080/JPA_Servlet_Category/home
echo   URL Dang nhap:      http://localhost:8080/JPA_Servlet_Category/login
echo ========================================================
echo.

if exist "%CATALINA_HOME%\bin\startup.bat" (
    call "%CATALINA_HOME%\bin\startup.bat"
) else (
    echo [LOI] Khong tim thay Apache Tomcat tai %CATALINA_HOME%
)
pause
