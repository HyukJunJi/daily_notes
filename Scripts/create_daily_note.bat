@echo off
setlocal enabledelayedexpansion

:: 설정 파일 경로
set "confFile=D:\MyNotes\Scripts\daily_note.conf"

:: 기본값 초기화
set "root="
set "logPath="

:: conf 파일에서 설정값 로드
for /f "tokens=1,* delims==" %%a in ('type "%confFile%"') do (
    if "%%a"=="ROOT_DIR" set "root=%%b"
    if "%%a"=="LOG_PATH" set "logPath=%%b"
)

:: 로그 폴더 없으면 생성
if not exist "%logPath%" mkdir "%logPath%"

set "logFile=%logPath%\create_log.txt"

:: 타임스탬프 생성
for /f "delims=" %%t in ('powershell -command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do (
    set "timestamp=%%t"
)

:: 오늘 날짜 계산
for /f "tokens=1-3 delims=-" %%a in ('powershell -command "Get-Date -Format yyyy-MM-dd"') do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
)

:: 오늘 파일 경로
set "folder=%root%\%year%\%month%"
set "filename=%year%-%month%-%day%.txt"
set "filepath=%folder%\%filename%"

:: 오늘 폴더 생성
if not exist "%folder%" (
    mkdir "%folder%"
    if !errorlevel! == 0 (
        echo [!timestamp!] [SUCCESS] Created folder: %folder% >> "%logFile%"
    ) else (
        echo [!timestamp!] [FAIL] Failed to create folder: %folder% >> "%logFile%"
    )
)

:: 오늘 메모 파일 생성
if not exist "%filepath%" (
    echo # %filename% > "%filepath%"
    if !errorlevel! == 0 (
        echo [!timestamp!] [SUCCESS] Created file: %filepath% >> "%logFile%"
    ) else (
        echo [!timestamp!] [FAIL] Failed to create file: %filepath% >> "%logFile%"
    )
) else (
    echo [!timestamp!] [INFO] File already exists: %filepath% >> "%logFile%"
)

:: 다음달 폴더 생성
set /a "nextMonth=1%month% + 1"
if !nextMonth! gtr 112 set /a "nextMonth-=100"

if !day! geq 29 (
    set /a "nextYear=%year%"
    if !nextMonth! gtr 12 (
        set /a "nextMonth=1"
        set /a "nextYear+=1"
    )
    if !nextMonth! lss 10 (
        set "nextMonth=0!nextMonth!"
    )
    set "nextFolder=%root%\!nextYear!\!nextMonth!"
    if not exist "!nextFolder!" (
        mkdir "!nextFolder!"
        if !errorlevel! == 0 (
            echo [!timestamp!] [SUCCESS] Created next month folder: !nextFolder! >> "%logFile%"
        ) else (
            echo [!timestamp!] [FAIL] Failed to create next month folder: !nextFolder! >> "%logFile%"
        )
    ) else (
        echo [!timestamp!] [INFO] Next month folder already exists: !nextFolder! >> "%logFile%"
    )
)

:: 다음 해 폴더 생성
if "%month%"=="12" (
    if "%day%"=="30" (
        set /a "nextYear=%year%+1"
        if not exist "%root%\!nextYear!" (
            mkdir "%root%\!nextYear!"
            if !errorlevel! == 0 (
                echo [!timestamp!] [SUCCESS] Created next year folder: %root%\!nextYear! >> "%logFile%"
            ) else (
                echo [!timestamp!] [FAIL] Failed to create next year folder: %root%\!nextYear! >> "%logFile%"
            )
        ) else (
            echo [!timestamp!] [INFO] Next year folder already exists: %root%\!nextYear! >> "%logFile%"
        )
    )
    if "%day%"=="31" (
        set /a "nextYear=%year%+1"
        if not exist "%root%\!nextYear!" (
            mkdir "%root%\!nextYear!"
            if !errorlevel! == 0 (
                echo [!timestamp!] [SUCCESS] Created next year folder: %root%\!nextYear! >> "%logFile%"
            ) else (
                echo [!timestamp!] [FAIL] Failed to create next year folder: %root%\!nextYear! >> "%logFile%"
            )
        ) else (
            echo [!timestamp!] [INFO] Next year folder already exists: %root%\!nextYear! >> "%logFile%"
        )
    )
)

if "%month%"=="01" if "%day%"=="01" (
    set /a "nextYear=%year%+1"
    if not exist "%root%\!nextYear!" (
        mkdir "%root%\!nextYear!"
        if !errorlevel! == 0 (
            echo [!timestamp!] [SUCCESS] Created next year folder: %root%\!nextYear! >> "%logFile%"
        ) else (
            echo [!timestamp!] [FAIL] Failed to create next year folder: %root%\!nextYear! >> "%logFile%"
        )
    ) else (
        echo [!timestamp!] [INFO] Next year folder already exists: %root%\!nextYear! >> "%logFile%"
    )
)

endlocal
exit
