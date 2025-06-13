@echo off
setlocal enabledelayedexpansion

:: Config file path
set "confFile=D:\MyNotes\Scripts\daily_note.conf"

:: Initialize
set "createXml="
set "openXml="
set "logPath="
set "createTaskName=CreateDailyNote"
set "openTaskName=OpenDailyNote"

:: Load values from config file
for /f "tokens=1,* delims==" %%a in ('type "%confFile%"') do (
    if "%%a"=="CREATE_XML_PATH" set "createXml=%%b"
    if "%%a"=="OPEN_XML_PATH" set "openXml=%%b"
    if "%%a"=="LOG_PATH" set "logPath=%%b"
)

:: Prepare log file
set "logFile=%logPath%\scheduler_log.txt"
if not exist "%logPath%" mkdir "%logPath%"

:: Get timestamp (with seconds)
for /f "delims=" %%t in ('powershell -command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do (
    set "timestamp=%%t"
)

:: Validate XML paths
if not exist "%createXml%" (
    echo [!timestamp!] [ERROR] CREATE_XML_PATH does not exist: %createXml% >> "%logFile%"
    echo [ERROR] CREATE_XML_PATH does not exist: %createXml%
    exit /b 1
)

if not exist "%openXml%" (
    echo [!timestamp!] [ERROR] OPEN_XML_PATH does not exist: %openXml% >> "%logFile%"
    echo [ERROR] OPEN_XML_PATH does not exist: %openXml%
    exit /b 1
)

:: Remove existing tasks (if any)
schtasks /delete /tn "%createTaskName%" /f >nul 2>&1
schtasks /delete /tn "%openTaskName%" /f >nul 2>&1

:: Register CreateDailyNote
schtasks /create /tn "%createTaskName%" /xml "%createXml%" /f >nul 2>&1
if !errorlevel! == 0 (
    echo [!timestamp!] [SUCCESS] %createTaskName% registered successfully. >> "%logFile%"
    echo [SUCCESS] %createTaskName% registered successfully.
) else (
    echo [!timestamp!] [FAIL] Failed to register %createTaskName%. >> "%logFile%"
    echo [FAIL] Failed to register %createTaskName%.
)

:: Register OpenDailyNote
schtasks /create /tn "%openTaskName%" /xml "%openXml%" /f >nul 2>&1
if !errorlevel! == 0 (
    echo [!timestamp!] [SUCCESS] %openTaskName% registered successfully. >> "%logFile%"
    echo [SUCCESS] %openTaskName% registered successfully.
) else (
    echo [!timestamp!] [FAIL] Failed to register %openTaskName%. >> "%logFile%"
    echo [FAIL] Failed to register %openTaskName%.
)

echo.
echo [INFO] Task registration completed. Log written to → %logFile%
endlocal
exit