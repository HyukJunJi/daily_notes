@echo off
setlocal enabledelayedexpansion

:: Config file path (daily_note.conf)
set "confFile=D:\MyNotes\Scripts\daily_note.conf"

:: 초기화
set "createTaskName=CreateDailyNote"
set "openTaskName=OpenDailyNote"
set "logPath="

:: Get LOG_PATH from conf
for /f "tokens=1,* delims==" %%a in ('type "%confFile%"') do (
    if "%%a"=="LOG_PATH" set "logPath=%%b"
)

:: Prepare log file
set "logFile=%logPath%\scheduler_log.txt"
if not exist "%logPath%" mkdir "%logPath%"

:: Timestamp
for /f "delims=" %%t in ('powershell -command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do (
    set "timestamp=%%t"
)

:: Delete CreateDailyNote
schtasks /delete /tn "%createTaskName%" /f >nul 2>&1
if !errorlevel! == 0 (
    echo [!timestamp!] [INFO] %createTaskName% deleted successfully. >> "%logFile%"
    echo [INFO] %createTaskName% deleted successfully.
) else (
    echo [!timestamp!] [WARN] %createTaskName% not found or already deleted. >> "%logFile%"
    echo [WARN] %createTaskName% not found or already deleted.
)

:: Delete OpenDailyNote
schtasks /delete /tn "%openTaskName%" /f >nul 2>&1
if !errorlevel! == 0 (
    echo [!timestamp!] [INFO] %openTaskName% deleted successfully. >> "%logFile%"
    echo [INFO] %openTaskName% deleted successfully.
) else (
    echo [!timestamp!] [WARN] %openTaskName% not found or already deleted. >> "%logFile%"
    echo [WARN] %openTaskName% not found or already deleted.
)

echo.
echo [INFO] Task unregistration completed. Log written to → %logFile%
endlocal
exit