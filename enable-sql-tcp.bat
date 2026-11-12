@echo off
chcp 65001 >nul
title Kich hoat TCP/IP va Port 1433 cho SQL Server

:: Kiem tra quyen Administrator va tu dong yeu cau nang quyen (UAC Self-Elevation)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [THONG BAO] Dang yeu cau quyen Administrator (UAC)...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~dpnx0\"\"' -Verb RunAs"
    exit /b
)

echo ========================================================
echo   BAT GIAO THUC TCP/IP VA PORT 1433 CHO SQL SERVER 2022
echo ========================================================
echo.

echo [1/3] Dang bat giao thuc TCP/IP tren instance SERVER2022...
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d "1433" /f
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SERVER2022\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpDynamicPorts /t REG_SZ /d "" /f

echo.
echo [2/3] Dang bat giao thuc TCP/IP tren cac instance mac dinh (neu co)...
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp" /v Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d "1433" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpDynamicPorts /t REG_SZ /d "" /f >nul 2>&1

echo.
echo [3/3] Dang khoi dong lai dich vu SQL Server de ap dung cau hinh...
net stop "MSSQL$SERVER2022" /y >nul 2>&1
net start "MSSQL$SERVER2022" >nul 2>&1
net start "SQLBrowser" >nul 2>&1

echo.
echo ========================================================
echo   DA KICH HOAT THANH CONG TCP/IP VA CONG 1433!
echo ========================================================
echo.
echo Neu can kiem tra bang giao dien SQL Server Configuration Manager:
echo   1. Nhan to hop phim Win + R, go: SQLServerManager16.msc
echo   2. Chon: SQL Server Network Configuration -> Protocols for SERVER2022
echo   3. Chon TCP/IP -> Chuyen sang 'Enabled = Yes'
echo   4. Tab IP Addresses -> keo xuong IPAll -> dat TCP Port = 1433, xoa TCP Dynamic Ports
echo   5. Khoi dong lai dich vu SQL Server (SERVER2022)
echo.
echo Nhan phim bat ky de thoat...
pause >nul
