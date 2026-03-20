@echo off
title Evoto Setup (Clean + Install + Snapshot)
chcp 65001 >nul 2>&1

:: === Tu dong nang quyen Admin ===
net session >nul 2>&1
if errorlevel 1 (
    echo [INFO] Dang yeu cau quyen Admin...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

set "BASE_DIR=%~dp0"
set "SNAPSHOT_DIR=%BASE_DIR%evoto_clean"

echo ============================================
echo   EVOTO SETUP (All-in-One)
echo   Clean + Install + Snapshot
echo ============================================
echo.

:: ========================================
:: PHAN 1: XOA SACH EVOTO CU (neu co)
:: ========================================
echo [PHAN 1] Xoa sach Evoto cu (neu co)...
echo.

echo   [1.1] Tat Evoto...
taskkill /IM evoto.exe /F >nul 2>&1
taskkill /IM "Evoto Update.exe" /F >nul 2>&1
timeout /t 2 >nul

echo   [1.2] Xoa AppData...
rmdir /S /Q "%LOCALAPPDATA%\Evoto" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Evoto_pro" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto_pro" >nul 2>&1

echo   [1.3] Xoa Registry...
reg delete "HKCU\Software\Evoto" /f >nul 2>&1
reg delete "HKCU\Software\Evoto_pro" /f >nul 2>&1
reg delete "HKLM\Software\Evoto" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Evoto" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Evoto" /f >nul 2>&1

echo   [1.4] Go cai dat Evoto...
set "EVOTO_DIR="
for /f "tokens=*" %%F in ('where /R "C:\Program Files" Evoto.exe 2^>nul') do set "EVOTO_DIR=%%~dpF"
if "%EVOTO_DIR%"=="" for /f "tokens=*" %%F in ('where /R "%LOCALAPPDATA%\Programs" Evoto.exe 2^>nul') do set "EVOTO_DIR=%%~dpF"
if "%EVOTO_DIR%"=="" for /f "tokens=*" %%F in ('where /R "%PROGRAMFILES(x86)%" Evoto.exe 2^>nul') do set "EVOTO_DIR=%%~dpF"

if not "%EVOTO_DIR%"=="" (
    echo     Tim thay Evoto tai: %EVOTO_DIR%
    if exist "%EVOTO_DIR%unins000.exe" (
        start /wait "" "%EVOTO_DIR%unins000.exe" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART
        timeout /t 3 >nul
    ) else if exist "%EVOTO_DIR%Uninstall Evoto.exe" (
        start /wait "" "%EVOTO_DIR%Uninstall Evoto.exe" --uninstall -s
        timeout /t 3 >nul
    )
    rmdir /S /Q "%EVOTO_DIR%" >nul 2>&1
) else (
    echo     Khong tim thay Evoto cu, bo qua.
)

echo   [1.5] Xoa shortcuts + folders con sot...
rmdir /S /Q "C:\Program Files\Evoto" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Programs\Evoto" >nul 2>&1
del /Q "%USERPROFILE%\Desktop\Evoto.lnk" >nul 2>&1
del /Q "%USERPROFILE%\Desktop\Evoto AI.lnk" >nul 2>&1
rmdir /S /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Evoto" >nul 2>&1
rmdir /S /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Evoto" >nul 2>&1

echo   [1.6] Xoa snapshot cu + temp...
rmdir /S /Q "%SNAPSHOT_DIR%" >nul 2>&1
del /Q "%TEMP%\evoto*" >nul 2>&1
rmdir /S /Q "%TEMP%\Evoto" >nul 2>&1

echo.
echo   [OK] Da xoa sach Evoto cu!
echo.

:: ========================================
:: PHAN 2: CAI DAT EVOTO
:: ========================================
echo [PHAN 2] Cai dat Evoto...
echo.

:: Tu dong tim file installer
set "INSTALLER="
for %%F in ("%BASE_DIR%EvotoInstaller*.exe") do set "INSTALLER=%%F"

if "%INSTALLER%"=="" (
    echo [ERROR] Khong tim thay file installer!
    echo         Dat file EvotoInstaller_xxx.exe cung thu muc voi script nay.
    pause
    exit /b 1
)

for %%A in ("%INSTALLER%") do (
    echo   File: %%~nxA
    echo   Size: %%~zA bytes
)
echo.

echo   [2.1] Dang cai dat Evoto...
echo         Neu hien giao dien cai dat, hay bam Install/Next.
echo.
start /wait "" "%INSTALLER%"
timeout /t 3 >nul

echo   [2.2] Kiem tra cai dat...
set "EVOTO_EXE="
for /f "tokens=*" %%F in ('where /R "C:\Program Files" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%LOCALAPPDATA%\Programs" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%PROGRAMFILES(x86)%" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%USERPROFILE%" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"

if "%EVOTO_EXE%"=="" (
    echo   [ERROR] Khong tim thay Evoto sau khi cai!
    pause
    exit /b 1
)
echo   [OK] Evoto da cai tai: %EVOTO_EXE%
echo.

:: ========================================
:: PHAN 3: MO EVOTO + CHO DONG
:: ========================================
echo [PHAN 3] Mo Evoto de tao du lieu...
echo.
echo   ==========================================
echo   Evoto dang mo. Ban can:
echo     1. Cho Evoto load xong (man hinh Login)
echo     2. KHONG DANG NHAP
echo     3. DONG Evoto lai
echo     4. Quay lai day bam phim bat ky
echo   ==========================================
echo.
start "" "%EVOTO_EXE%"
pause

:: ========================================
:: PHAN 4: CHUP SNAPSHOT
:: ========================================
echo.
echo [PHAN 4] Chup snapshot trang thai sach...
echo.

echo   [4.1] Tat Evoto...
taskkill /IM evoto.exe /F >nul 2>&1
timeout /t 2 >nul

echo   [4.2] Tao thu muc snapshot...
if not exist "%SNAPSHOT_DIR%" mkdir "%SNAPSHOT_DIR%"

echo   [4.3] Sao chep Roaming AppData...
if exist "%APPDATA%\Evoto-worker" (
    mkdir "%SNAPSHOT_DIR%\Roaming_worker" >nul 2>&1
    robocopy "%APPDATA%\Evoto-worker" "%SNAPSHOT_DIR%\Roaming_worker" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    echo     Evoto-worker Roaming: OK
) else (
    echo     Evoto-worker Roaming: SKIP
)
if exist "%APPDATA%\Evoto_pro" (
    mkdir "%SNAPSHOT_DIR%\Roaming_pro" >nul 2>&1
    robocopy "%APPDATA%\Evoto_pro" "%SNAPSHOT_DIR%\Roaming_pro" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    echo     Evoto_pro Roaming: OK
) else (
    echo     Evoto_pro Roaming: SKIP
)

echo   [4.4] Sao chep Local AppData...
if exist "%LOCALAPPDATA%\Evoto-worker" (
    mkdir "%SNAPSHOT_DIR%\Local_worker" >nul 2>&1
    robocopy "%LOCALAPPDATA%\Evoto-worker" "%SNAPSHOT_DIR%\Local_worker" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    echo     Evoto-worker Local: OK
) else (
    echo     Evoto-worker Local: SKIP
)
if exist "%LOCALAPPDATA%\Evoto_pro" (
    mkdir "%SNAPSHOT_DIR%\Local_pro" >nul 2>&1
    robocopy "%LOCALAPPDATA%\Evoto_pro" "%SNAPSHOT_DIR%\Local_pro" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    echo     Evoto_pro Local: OK
) else (
    echo     Evoto_pro Local: SKIP
)

echo   [4.5] Xuat Registry...
reg export "HKCU\Software\Evoto_pro" "%SNAPSHOT_DIR%\evoto_pro.reg" /y >nul 2>&1
if %errorlevel% equ 0 (
    echo     Registry Evoto_pro: OK
) else (
    echo     Registry Evoto_pro: SKIP
)

echo   [4.6] Luu duong dan Evoto.exe...
echo %EVOTO_EXE%>"%SNAPSHOT_DIR%\evoto_path.txt"
echo     Saved: %EVOTO_EXE%

echo.
echo ============================================
echo   SETUP HOAN TAT!
echo ============================================
echo.
echo   Snapshot da luu tai: %SNAPSHOT_DIR%
echo.
echo   Bay gio ban co the:
echo   - Mo Evoto, dang nhap account bat ky
echo   - Khi muon doi account: chay reset.bat
echo.
pause
