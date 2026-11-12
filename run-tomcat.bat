@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   KHOI DONG APACHE TOMCAT CHO DU AN JPA 3.0
echo   URL Category (JPA): http://localhost:8080/JPA_Servlet_Category/admin/categories
echo   URL Trang chu:      http://localhost:8080/JPA_Servlet_Category/home
echo   URL Dang nhap:      http://localhost:8080/JPA_Servlet_Category/login
echo ========================================================
echo.

:: 1. Kiem tra JAVA_HOME
if "%JAVA_HOME%"=="" (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr" (
        set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
    ) else if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    ) else if exist "C:\Program Files\Java\jdk-17" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-17"
    )
)

:: 2. Tu dong tim kiem CATALINA_HOME tren moi o dia
set "FOUND_TOMCAT="
if not "%CATALINA_HOME%"=="" (
    if exist "%CATALINA_HOME%\bin\startup.bat" set "FOUND_TOMCAT=%CATALINA_HOME%"
)
if "!FOUND_TOMCAT!"=="" if exist "E:\apache-tomcat-11.0.27\bin\startup.bat" set "FOUND_TOMCAT=E:\apache-tomcat-11.0.27"
if "!FOUND_TOMCAT!"=="" if exist "C:\apache-tomcat-11.0.27\bin\startup.bat" set "FOUND_TOMCAT=C:\apache-tomcat-11.0.27"
if "!FOUND_TOMCAT!"=="" if exist "D:\apache-tomcat-11.0.27\bin\startup.bat" set "FOUND_TOMCAT=D:\apache-tomcat-11.0.27"

if not "!FOUND_TOMCAT!"=="" (
    echo [INFO] Tim thay Apache Tomcat tai: !FOUND_TOMCAT!
    set "CATALINA_HOME=!FOUND_TOMCAT!"
    call "!FOUND_TOMCAT!\bin\startup.bat"
) else (
    echo [LOI] Khong tim thay thu muc cai dat Apache Tomcat tu dong.
    echo Vui long thiet lap bien moi truong CATALINA_HOME hoac khoi dong Tomcat tu IDE cua ban (IntelliJ / Eclipse).
)
pause
