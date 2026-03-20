@echo off
title Evoto - Tao Snapshot Fresh (Chua Dang Nhap)
chcp 65001 >nul 2>&1

:: Lay thu muc chua script
set "BASE_DIR=%~dp0"
set "SNAPSHOT_DIR=%BASE_DIR%evoto_clean"

echo ============================================
echo   EVOTO SNAPSHOT CREATOR
echo   Chup trang thai FRESH (chua dang nhap)
echo ============================================
echo.
echo   [QUAN TRONG] Chi chay script nay khi:
echo   - Evoto DA CAI xong
echo   - Evoto CHUA DANG NHAP tai khoan nao
echo   - Evoto dang o man hinh Login
echo.

echo.
echo [1] Dang tat Evoto...
taskkill /IM evoto.exe /F >nul 2>&1
timeout /t 2 >nul

echo [2] Tao thu muc snapshot...
if not exist "%SNAPSHOT_DIR%" mkdir "%SNAPSHOT_DIR%"
if not exist "%SNAPSHOT_DIR%\Local_worker" mkdir "%SNAPSHOT_DIR%\Local_worker"
if not exist "%SNAPSHOT_DIR%\Local_pro" mkdir "%SNAPSHOT_DIR%\Local_pro"
if not exist "%SNAPSHOT_DIR%\Roaming_worker" mkdir "%SNAPSHOT_DIR%\Roaming_worker"
if not exist "%SNAPSHOT_DIR%\Roaming_pro" mkdir "%SNAPSHOT_DIR%\Roaming_pro"

echo [3] Sao chep Local AppData (Evoto-worker)...
if exist "%LOCALAPPDATA%\Evoto-worker" (
    robocopy "%LOCALAPPDATA%\Evoto-worker" "%SNAPSHOT_DIR%\Local_worker" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    if errorlevel 8 (
        echo [ERROR] Loi khi sao chep Evoto-worker Local!
        pause
        exit /b 1
    )
) else (
    echo     [SKIP] Khong tim thay Evoto-worker Local
)

echo [4] Sao chep Local AppData (Evoto_pro)...
if exist "%LOCALAPPDATA%\Evoto_pro" (
    robocopy "%LOCALAPPDATA%\Evoto_pro" "%SNAPSHOT_DIR%\Local_pro" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    if errorlevel 8 (
        echo [ERROR] Loi khi sao chep Evoto_pro Local!
        pause
        exit /b 1
    )
) else (
    echo     [SKIP] Khong tim thay Evoto_pro Local
)

echo [5] Sao chep Roaming AppData (Evoto-worker)...
if exist "%APPDATA%\Evoto-worker" (
    robocopy "%APPDATA%\Evoto-worker" "%SNAPSHOT_DIR%\Roaming_worker" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    if errorlevel 8 (
        echo [ERROR] Loi khi sao chep Evoto-worker Roaming!
        pause
        exit /b 1
    )
) else (
    echo     [SKIP] Khong tim thay Evoto-worker Roaming
)

echo [6] Sao chep Roaming AppData (Evoto_pro)...
if exist "%APPDATA%\Evoto_pro" (
    robocopy "%APPDATA%\Evoto_pro" "%SNAPSHOT_DIR%\Roaming_pro" /E /PURGE /NFL /NDL /NJH /NJS /nc /ns /np
    if errorlevel 8 (
        echo [ERROR] Loi khi sao chep Evoto_pro Roaming!
        pause
        exit /b 1
    )
) else (
    echo     [SKIP] Khong tim thay Evoto_pro Roaming
)

echo [7] Xuat Registry...
reg export "HKCU\Software\Evoto_pro" "%SNAPSHOT_DIR%\evoto_pro.reg" /y >nul 2>&1
if %errorlevel% equ 0 (
    echo     Registry Evoto_pro da xuat thanh cong.
) else (
    echo     [INFO] Khong co registry key Evoto_pro - binh thuong neu moi cai.
)

echo [8] Luu duong dan Evoto.exe...
set "EVOTO_EXE="
for /f "tokens=*" %%F in ('where /R "C:\Program Files" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%LOCALAPPDATA%\Programs" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if "%EVOTO_EXE%"=="" for /f "tokens=*" %%F in ('where /R "%PROGRAMFILES(x86)%" Evoto.exe 2^>nul') do set "EVOTO_EXE=%%F"
if not "%EVOTO_EXE%"=="" (
    echo %EVOTO_EXE%>"%SNAPSHOT_DIR%\evoto_path.txt"
    echo     Saved: %EVOTO_EXE%
) else (
    echo     [WARN] Khong tim thay Evoto.exe
)

echo.
echo ============================================
echo   HOAN TAT! Snapshot FRESH da luu tai:
echo   %SNAPSHOT_DIR%
echo ============================================
echo.
echo   Bay gio ban co the:
echo   - Mo Evoto, dang nhap account bat ky
echo   - Khi muon doi account: chay reset_evoto.bat
echo.
pause
