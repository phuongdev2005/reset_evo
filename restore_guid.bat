@echo off
title Khoi phuc MachineGuid goc
chcp 65001 >nul 2>&1

:: === Tu dong nang quyen Admin ===
net session >nul 2>&1
if errorlevel 1 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

set "BASE_DIR=%~dp0"
set "GUID_FILE=%BASE_DIR%evoto_clean\original_guid.txt"

if not exist "%GUID_FILE%" (
    echo [ERROR] Khong tim thay file backup GUID goc!
    pause
    exit /b 1
)

set /p ORIGINAL_GUID=<"%GUID_FILE%"
reg add "HKLM\SOFTWARE\Microsoft\Cryptography" /v MachineGuid /t REG_SZ /d "%ORIGINAL_GUID%" /f >nul 2>&1

echo.
echo ============================================
echo   Da khoi phuc MachineGuid goc:
echo   %ORIGINAL_GUID%
echo ============================================
echo.
pause
