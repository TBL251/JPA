@echo off
chcp 65001 >nul
echo ========================================================
echo   BAT DAU DONG GOI PROJECT JPA 3.0 VOI MAVEN
echo ========================================================

set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
set "PATH=%JAVA_HOME%\bin;C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin;%PATH%"

cd /d "%~dp0"
call "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd" clean package -DskipTests

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   BUILD THANH CONG!
    echo   Dang copy file WAR vao Apache Tomcat 11 webapps...
    echo ========================================================
    if exist "E:\apache-tomcat-11.0.27\webapps" (
        copy /Y "target\JPA_Servlet_Category.war" "E:\apache-tomcat-11.0.27\webapps\"
        echo   Da copy WAR thanh cong: E:\apache-tomcat-11.0.27\webapps\JPA_Servlet_Category.war
    )
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   BUILD THAT BAI! Vui long kiem tra lai loi bien dich.
    echo ========================================================
)
pause

