@echo off
title Evoto - Xoa Sach Hoan Toan
chcp 65001 >nul 2>&1

:: === Tu dong nang quyen Admin ===
net session >nul 2>&1
if errorlevel 1 (
    echo [INFO] Dang yeu cau quyen Admin...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Lay thu muc chua script
set "BASE_DIR=%~dp0"
set "SNAPSHOT_DIR=%BASE_DIR%evoto_clean"

echo ============================================
echo   EVOTO FULL CLEAN / UNINSTALL TOOL
echo   Xoa sach moi thu lien quan den Evoto
echo ============================================
echo.
echo [CANH BAO] Script nay se:
echo   - Tat Evoto
echo   - Xoa toan bo du lieu Evoto
echo   - Xoa Registry, shortcuts
echo   - Go cai dat Evoto
echo   - Xoa snapshot backup
echo.
echo.
echo [1] Dang tat Evoto...
taskkill /IM evoto.exe /F >nul 2>&1
taskkill /IM "Evoto Update.exe" /F >nul 2>&1
timeout /t 2 >nul

echo [2] Xoa du lieu AppData (Local)...
rmdir /S /Q "%LOCALAPPDATA%\Evoto" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Evoto_pro" >nul 2>&1

echo [3] Xoa du lieu AppData (Roaming)...
rmdir /S /Q "%APPDATA%\Evoto" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto_pro" >nul 2>&1

echo [4] Xoa Registry...
reg delete "HKCU\Software\Evoto" /f >nul 2>&1
reg delete "HKCU\Software\Evoto_pro" /f >nul 2>&1
reg delete "HKLM\Software\Evoto" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Evoto" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Evoto" /f >nul 2>&1

echo [5] Tim va go cai dat Evoto...
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
    echo     Khong tim thay Evoto, bo qua.
)

echo [6] Xoa folder Evoto con sot (neu co)...
rmdir /S /Q "C:\Program Files\Evoto" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Programs\Evoto" >nul 2>&1

echo [7] Xoa Evoto khoi Desktop + Start Menu...
del /Q "%USERPROFILE%\Desktop\Evoto.lnk" >nul 2>&1
del /Q "%USERPROFILE%\Desktop\Evoto AI.lnk" >nul 2>&1
rmdir /S /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Evoto" >nul 2>&1
rmdir /S /Q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Evoto" >nul 2>&1

echo [8] Xoa snapshot backup...
rmdir /S /Q "%SNAPSHOT_DIR%" >nul 2>&1

echo [9] Don dep Temp files...
del /Q "%TEMP%\evoto*" >nul 2>&1
rmdir /S /Q "%TEMP%\Evoto" >nul 2>&1

echo.
echo ============================================
echo   HOAN TAT! Evoto da bi xoa sach.
echo   May tinh sach nhu chua tung cai Evoto.
echo ============================================
echo.
pause
