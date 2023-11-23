:: Created by FlyEmoji
:: You can Find this Project at https://github.com/FLYEMOJ1/RiotClient-League-LanguageSelector-Windows
::
:: This Project is using MIT License
::
:: If you paid for this batch. You are got scammed. This is a free software(?)
::
::
:: 本命令行工具由 FlyEmoji 创作
:: 您可以在 https://github.com/FLYEMOJ1/RiotClient-League-LanguageSelector-Windows 找到最新版本的工具。
:: 
:: 本工具使用了 MIT License
::
:: 如果您花钱购买了该工具，那证明你已经被骗钱了。这是个免费软件。

@echo off
setlocal enabledelayedexpansion
set version=v1.0.4
set GITHUB_REPO=FLYEMOJ1/RiotClient-League-LanguageSelector-Windows
set REPO_NAME=RiotClient-League-LanguageSelector-Windows
set TEMP_DIR=%TEMP%\RiotClientLanguageSelector_update_temp
set "INSTALL_DIR=%~p0"

:: getAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto getAdmin
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:getAdmin
pushd "%CD%"
CD /D "%~dp0"

echo Running with administrative privileges. To make sure this will work.
echo Checking Updates.

:: Force remove temp files. and create temp directory.
rd /s /q "%TEMP_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

cd "%TEMP_DIR%"

:: Get latest version.
curl -s "https://api.github.com/repos/%GITHUB_REPO%/releases/latest" > latest_release.json

:: Resolve JSON and get version code
for /f "tokens=2 delims=:, " %%I in ('type latest_release.json ^| find /i "tag_name"') do set REMOTE_VERSION=%%~I

if "%REMOTE_VERSION%"=="" (
    echo Cannot get latest version. Please Check GitHub Releases API is available?
    goto :preload
)

:: Compare local and remote version. If local version is newer or equal, then skip update.
if "%version%" geq "%REMOTE_VERSION%" (
    echo You have the Latest Version of leagueClient Language Selector.
    goto :preload
)

echo Latest version is: %REMOTE_VERSION%

echo Downloading latest version...

:: Download latest version. (from GitHub and ZIP)
curl -L "https://codeload.github.com/FLYEMOJ1/RiotClient-League-LanguageSelector-Windows/zip/refs/heads/main" -o update.zip

:: Decompress to temp.
powershell Expand-Archive -Path update.zip -DestinationPath .

:: Copy update file to installation location.
xcopy /y "%TEMP_DIR%\%REPO_NAME%-main\RiotClientLanguageSelector.bat" "%INSTALL_DIR%"

echo Update Complete.
start "" "%INSTALL_DIR%\RiotClientLanguageSelector.bat"
goto end

:update_Cleanup
:: Remove temp files.
del /q update.zip
cd ..
rd /s /q "%TEMP_DIR%"

:preload
:: Force Riot Client Off.
title PreLoading... 0%
echo Killing Riot Game Clients.
taskkill /t /f /im LeagueClient.exe >nul 2>&1
title PreLoading... 10%
echo PreLoading... 10%
taskkill /t /f /im LeagueClientUx.exe >nul 2>&1
taskkill /t /f /im LeagueClientUxRender.exe >nul 2>&1
title PreLoading... 30%
echo PreLoading... 30%
taskkill /t /f /im LeagueCrashHandler64.exe >nul 2>&1
taskkill /t /f /im RiotClientCrashHandler.exe >nul 2>&1
taskkill /t /f /im RiotClientServices.exe >nul 2>&1
title PreLoading... 60%
echo PreLoading... 60%
taskkill /t /f /im RiotClientUx.exe >nul 2>&1
taskkill /t /f /im RiotClientUxRender.exe >nul 2>&1
title PreLoading... 80%
echo PreLoading... 80%
taskkill /t /f /im VALORANT.exe >nul 2>&1
title PreLoading... 100%
echo PreLoading... 100%
cls
echo If stuck at here, Please press enter.
:: End of cleanup.

title League of Legends Language Selector %version%

:: Set Where leagueClient info file is gonna save.
set "leagueClient_info_file=%userprofile%\leagueClient_info.txt"

:: Check if leagueClient_Info.txt exists. If not, then let the user manually input the leagueClient directory.
if not exist "%leagueClient_info_file%" (
    echo Please manually input the leagueClient directory. no exe, only directory.
    set /p "leagueClient_path="
    echo !leagueClient_path!> "%leagueClient_info_file%"
) else (
    :: Read leagueClient directory from the saved file.
    set /p leagueClient_path=<"%leagueClient_info_file%"
)

:: Show Language Select menu
:language_menu
cls
echo Select Language:
echo 1. English
echo 2. Chinese Simplified
echo 3. Chinese Traditional
echo 4. Japanese
echo 5. Korean
echo 6. Exit

set /p "language_choice="

if "%language_choice%"=="1" (
    set "language=en_US"
) else if "%language_choice%"=="2" (
    set "language=zh_CN"
) else if "%language_choice%"=="3" (
    set "language=zh_TW"
) else if "%language_choice%"=="4" (
    set "language=ja_JP"
) else if "%language_choice%"=="5" (
    set "language=ko_KR"
) else if "%language_choice%"=="6" (
    exit
) else (
    echo JUST INPUT A NUMBER !!!
    pause
    goto :language_menu
)

:: Start LeagueClient.exe with the selected language.
echo
start "" "%leagueClient_path%\LeagueClient.exe" "--locale=!language!"

:end