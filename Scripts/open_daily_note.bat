@echo off
setlocal enabledelayedexpansion

:: 설정 파일 경로
set "confFile=D:\MyNotes\Scripts\daily_note.conf"

:: 기본값 초기화
set "root="
set "notepadPath="
set "logPath="

:: conf 파일에서 설정값 로드
for /f "tokens=1,* delims==" %%a in ('type "%confFile%"') do (
    if "%%a"=="ROOT_DIR" set "root=%%b"
    if "%%a"=="NOTEPAD_PATH" set "notepadPath=%%b"
    if "%%a"=="LOG_PATH" set "logPath=%%b"
)

:: 로그 경로 설정
set "logFile=%logPath%\open_log.txt"
if not exist "%logPath%" mkdir "%logPath%"

:: timestamp 생성
for /f "delims=" %%t in ('powershell -command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do (
    set "timestamp=%%t"
)

:: 오늘 날짜 계산
for /f "tokens=1-3 delims=-" %%a in ('powershell -command "Get-Date -Format yyyy-MM-dd"') do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
)

:: 메모 파일 경로
set "filePath=%root%\%year%\%month%\%year%-%month%-%day%.txt"

:: Notepad 실행 및 로그 작성
if exist "%filePath%" (
    call "%notepadPath%" "%filePath%"
    if !errorlevel! == 0 (
        echo [!timestamp!] [SUCCESS] Opened file: %filePath% using %notepadPath% >> "%logFile%"
    ) else (
        echo [!timestamp!] [FAIL] Failed to open file: %filePath% using %notepadPath% >> "%logFile%"
    )
) else (
    echo [!timestamp!] [FAIL] File not found: %filePath% >> "%logFile%"
)

endlocal
exit