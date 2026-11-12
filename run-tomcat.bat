@echo off
if defined CATALINA_HOME (
    set "TOMCAT_DIR=%CATALINA_HOME%"
) else if exist "E:\apache-tomcat-11.0.27\bin\startup.bat" (
    set "TOMCAT_DIR=E:\apache-tomcat-11.0.27"
) else if exist "C:\apache-tomcat-11.0.27\bin\startup.bat" (
    set "TOMCAT_DIR=C:\apache-tomcat-11.0.27"
) else if exist "D:\apache-tomcat-11.0.27\bin\startup.bat" (
    set "TOMCAT_DIR=D:\apache-tomcat-11.0.27"
)

if not defined JAVA_HOME (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr" (
        set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
    )
)

if defined TOMCAT_DIR (
    set "CATALINA_HOME=%TOMCAT_DIR%"
)

echo ========================================================
echo   KHOI DONG APACHE TOMCAT CHO DU AN JPA 3.0
echo   URL Category (JPA): http://localhost:8080/JPA_Servlet_Category/admin/categories
echo   URL Trang chu:      http://localhost:8080/JPA_Servlet_Category/home
echo   URL Dang nhap:      http://localhost:8080/JPA_Servlet_Category/login
echo ========================================================
echo.

if exist "%CATALINA_HOME%\bin\startup.bat" (
    call "%CATALINA_HOME%\bin\startup.bat"
) else (
    echo [LOI] Khong tim thay Apache Tomcat.
    echo Vui long kiem tra lai duong dan hoac cai dat bien moi truong CATALINA_HOME.
)
pause
