@echo off
chcp 65001 >nul
title Day ma nguon len GitHub
echo ========================================================
echo   DANG DAY TOAN BO MA NGUON LEN GITHUB (TBL251/JPA)...
echo ========================================================
echo.
cd /d "%~dp0"
git push -f origin main
if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   DA DAY MA NGUON LEN GITHUB THANH CONG!
    echo   Link: https://github.com/TBL251/JPA.git
    echo ========================================================
) else (
    echo.
    echo [LOI] Khong the day len GitHub. Vui long kiem tra lai ket noi hoac quyen truy cap.
)
pause
