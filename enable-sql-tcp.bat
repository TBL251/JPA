@echo off
chcp 65001 >nul
echo ========================================================
echo   BAT GIAO THUC TCP/IP VA PORT 1433 CHO SQL SERVER 2022
echo ========================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [THONG BAO QUAN TRONG]
    echo Vui long chay file nay bang cach:
    echo   1. Nhap chuot PHAI vao file 'enable-sql-tcp.bat'
    echo   2. Chon 'Run as administrator' (Chay voi quyen quan tri vien)
    echo.
    pause
    exit /b 1
)

echo Dang bat giao thuc TCP/IP tren SQL Server (SERVER2022)...
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d "1433" /f
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpDynamicPorts /t REG_SZ /d "" /f

echo.
echo Dang khoi dong lai dich vu SQL Server (SERVER2022)...
net stop "MSSQL$SERVER2022" /y
net start "MSSQL$SERVER2022"

echo.
echo ========================================================
echo   DA BAT THANH CONG TCP/IP VA CONG 1433 CHO SQL SERVER!
echo ========================================================
pause
