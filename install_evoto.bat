@echo off
title Evoto Auto Install Tool
chcp 65001 >nul 2>&1

:: Lay thu muc chua script
set "BASE_DIR=%~dp0"

:: === Tu dong tim file installer ===
set "INSTALLER="
for %%F in ("%BASE_DIR%EvotoInstaller*.exe") do set "INSTALLER=%%F"

echo ============================================
echo   EVOTO AUTO INSTALL TOOL
echo ============================================
echo.

:: === Kiem tra file installer ===
if "%INSTALLER%"=="" (
    echo [ERROR] Khong tim thay file installer!
    echo         Dat file EvotoInstaller_xxx.exe cung thu muc voi script nay.
    pause
    exit /b 1
)

for %%A in ("%INSTALLER%") do (
    echo [INFO] File: %%~nxA
    echo [INFO] Size: %%~zA bytes
)
echo.

:: === Tat Evoto neu dang chay ===
echo [1] Dang tat Evoto (neu dang chay)...
taskkill /IM evoto.exe /F >nul 2>&1
timeout /t 1 >nul

:: === Cai dat ===
echo [2] Dang mo cai dat Evoto...
echo     Neu hien giao dien cai dat, hay bam Install/Next.
echo     Script se tu dong tiep tuc khi cai xong.
echo.
start /wait "" "%INSTALLER%"
timeout /t 3 >nul

:: === Kiem tra cai dat ===
echo [3] Kiem tra cai dat...
set "EVOTO_EXE="
for /f "tokens=*" %%F in ('where /R "C:\Program Files" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%LOCALAPPDATA%\Programs" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%PROGRAMFILES(x86)%" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%USERPROFILE%" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"

if not "%EVOTO_EXE%"=="" (
    echo     [OK] Cai dat thanh cong!
    echo     Duong dan: %EVOTO_EXE%
) else (
    echo     [WARN] Khong tim thay Evoto. Vui long cai thu cong.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   HOAN TAT!
echo ============================================
echo.
echo   Buoc tiep theo:
echo   1. Mo Evoto, KHONG dang nhap
echo   2. Dong Evoto lai
echo   3. Chay "prepare_snapshot.bat"
echo.
pause
