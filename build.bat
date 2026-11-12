@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   BAT DAU BUILD VA DONG GOI DU AN JPA 3.0
echo ========================================================

:: 1. Kiem tra va thiet lap JAVA_HOME neu chua co
if "%JAVA_HOME%"=="" (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr" (
        set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
    ) else if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    ) else if exist "C:\Program Files\Java\jdk-17" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-17"
    )
)

if not "%JAVA_HOME%"=="" (
    set "PATH=%JAVA_HOME%\bin;%PATH%"
    echo [INFO] Su dung JAVA_HOME: %JAVA_HOME%
)

:: 2. Xac dinh lenh Maven (mvn)
set "MVN_CMD=mvn"
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd" (
        set "MVN_CMD=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd"
    )
)

cd /d "%~dp0"
echo [INFO] Dang chay Maven package...
call "%MVN_CMD%" clean package -DskipTests

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   BUILD THANH CONG!
    echo   File WAR duoc tao tai: target\JPA_Servlet_Category.war
    echo ========================================================

    :: 3. Tu dong tim kiem thu muc Tomcat webapps
    set "TARGET_WEBAPPS="
    if not "%CATALINA_HOME%"=="" (
        if exist "%CATALINA_HOME%\webapps" set "TARGET_WEBAPPS=%CATALINA_HOME%\webapps"
    )
    if "!TARGET_WEBAPPS!"=="" if exist "E:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=E:\apache-tomcat-11.0.27\webapps"
    if "!TARGET_WEBAPPS!"=="" if exist "C:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=C:\apache-tomcat-11.0.27\webapps"
    if "!TARGET_WEBAPPS!"=="" if exist "D:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=D:\apache-tomcat-11.0.27\webapps"

    if not "!TARGET_WEBAPPS!"=="" (
        echo   Dang copy file WAR vao: !TARGET_WEBAPPS!\
        copy /Y "target\JPA_Servlet_Category.war" "!TARGET_WEBAPPS!\"
        echo   Da copy WAR thanh cong!
    ) else (
        echo [CHU Y] Khong tim thay thu muc Tomcat tu dong.
        echo Ban co the copy file 'target\JPA_Servlet_Category.war' vao thu muc 'webapps' cua Tomcat tren may ban.
    )
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   BUILD THAT BAI! Vui long kiem tra lai loi bien dich.
    echo ========================================================
)
pause
