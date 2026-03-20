@echo off
title Evoto Reset
chcp 65001 >nul 2>&1

:: === Tu dong nang quyen Admin (can de doi MachineGuid) ===
net session >nul 2>&1
if errorlevel 1 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

set "BASE_DIR=%~dp0"
set "SNAPSHOT_DIR=%BASE_DIR%evoto_clean"

:: Kiem tra snapshot
if not exist "%SNAPSHOT_DIR%" (
    echo [ERROR] Chua co snapshot! Chay setup.bat truoc.
    pause
    exit /b 1
)

echo [1] Tat Evoto...
taskkill /IM evoto.exe /F >nul 2>&1

echo [2] Xoa du lieu cu...
rmdir /S /Q "%LOCALAPPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%LOCALAPPDATA%\Evoto_pro" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto-worker" >nul 2>&1
rmdir /S /Q "%APPDATA%\Evoto_pro" >nul 2>&1
reg delete "HKCU\Software\Evoto_pro" /f >nul 2>&1

echo [3] Khoi phuc snapshot...
if exist "%SNAPSHOT_DIR%\Local_worker" robocopy "%SNAPSHOT_DIR%\Local_worker" "%LOCALAPPDATA%\Evoto-worker" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
if exist "%SNAPSHOT_DIR%\Local_pro" robocopy "%SNAPSHOT_DIR%\Local_pro" "%LOCALAPPDATA%\Evoto_pro" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
if exist "%SNAPSHOT_DIR%\Roaming_worker" robocopy "%SNAPSHOT_DIR%\Roaming_worker" "%APPDATA%\Evoto-worker" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
if exist "%SNAPSHOT_DIR%\Roaming_pro" robocopy "%SNAPSHOT_DIR%\Roaming_pro" "%APPDATA%\Evoto_pro" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
if exist "%SNAPSHOT_DIR%\evoto_pro.reg" reg import "%SNAPSHOT_DIR%\evoto_pro.reg" >nul 2>&1

echo [4] Doi MachineGuid...
:: Backup GUID goc (chi lan dau)
if not exist "%SNAPSHOT_DIR%\original_guid.txt" (
    for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Cryptography" /v MachineGuid 2^>nul ^| findstr MachineGuid') do (
        echo %%A>"%SNAPSHOT_DIR%\original_guid.txt"
    )
)
:: Tao GUID moi
for /f %%G in ('powershell -Command "[guid]::NewGuid().ToString()"') do set "NEW_GUID=%%G"
reg add "HKLM\SOFTWARE\Microsoft\Cryptography" /v MachineGuid /t REG_SZ /d "%NEW_GUID%" /f >nul 2>&1
echo     GUID: %NEW_GUID%

echo [5] Mo Evoto...
if exist "%SNAPSHOT_DIR%\evoto_path.txt" (
    set /p EVOTO_EXE=<"%SNAPSHOT_DIR%\evoto_path.txt"
)
if defined EVOTO_EXE (
    start "" "%EVOTO_EXE%"
) else (
    echo     [WARN] Khong tim thay Evoto.exe
)

echo DONE!
exit
