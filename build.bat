@echo off
if not defined JAVA_HOME (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr" (
        set "JAVA_HOME=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\jbr"
    )
)

if defined JAVA_HOME (
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

set "MVN_CMD=mvn"
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    if exist "C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd" (
        set "MVN_CMD=C:\Users\Admin\AppData\Local\Programs\IntelliJ IDEA\plugins\maven\lib\maven3\bin\mvn.cmd"
    )
)

echo ========================================================
echo   BAT DAU BUILD VA DONG GOI DU AN JPA 3.0
echo ========================================================

cd /d "%~dp0"
call "%MVN_CMD%" clean package -DskipTests

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   BUILD THANH CONG!
    echo   File WAR duoc tao tai: target\JPA_Servlet_Category.war
    echo ========================================================

    set "TARGET_WEBAPPS="
    if defined CATALINA_HOME (
        if exist "%CATALINA_HOME%\webapps" set "TARGET_WEBAPPS=%CATALINA_HOME%\webapps"
    )
    if not defined TARGET_WEBAPPS if exist "E:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=E:\apache-tomcat-11.0.27\webapps"
    if not defined TARGET_WEBAPPS if exist "C:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=C:\apache-tomcat-11.0.27\webapps"
    if not defined TARGET_WEBAPPS if exist "D:\apache-tomcat-11.0.27\webapps" set "TARGET_WEBAPPS=D:\apache-tomcat-11.0.27\webapps"

    if defined TARGET_WEBAPPS (
        copy /Y "target\JPA_Servlet_Category.war" "%TARGET_WEBAPPS%\"
        echo   Da copy WAR thanh cong vao: %TARGET_WEBAPPS%\
    ) else (
        echo [CHU Y] Vui long copy file target\JPA_Servlet_Category.war vao thu muc webapps cua Tomcat.
    )
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   BUILD THAT BAI! Vui long kiem tra lai loi bien dich.
    echo ========================================================
)
pause
