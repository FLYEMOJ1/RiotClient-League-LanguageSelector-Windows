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
::
::
:: Last Update: KST 2023-11-22 9:40 PM
:: Update log: Add a taskkill set to Force LeagueClient off.

@echo off
setlocal enabledelayedexpansion

:: getAdmin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

echo Running with administrative privileges. To make sure this will work.

:: Force Riot Client Off.
title PreLoading...
cls
echo Killing Riot Game Clients.
taskkill /t /f /im LeagueClient.exe
title PreLoading... 10%
taskkill /t /f /im LeagueClientUx.exe
taskkill /t /f /im LeagueClientUxRender.exe
title PreLoading... 30%
taskkill /t /f /im LeagueCrashHandler64.exe
taskkill /t /f /im RiotClientCrashHandler.exe
taskkill /t /f /im RiotClientServices.exe
title PreLoading... 60%
taskkill /t /f /im RiotClientUx.exe
taskkill /t /f /im RiotClientUxRender.exe
title PreLoading... 80%
taskkill /t /f /im VALORANT.exe
title PreLoading... 100%
cls
:: End of Shit hole.

:: Start of Title set.

title League of Legends Language Selector

:: End of Title set.

:: Set Where leagueClient info file is gonna save.
set "leagueClient_info_file=%userprofile%\leagueClient_info.txt"

:: Check leagueClient_Info.txt exist. If not, then let user manualy input.
if not exist "%leagueClient_info_file%" (
    echo Please manual input leagueClient directory *no exe only directory*
    set /p "leagueClient_path="
    echo !leagueClient_path!> "%leagueClient_info_file%"
) else (
:: From Saved file to read leagueClient Directory.
    set /p leagueClient_path=<"%leagueClient_info_file%"
)

:: Show Language Select menu
:language_menu
cls
echo Select Language:
echo 1. English
echo 2. Chinese Simplified
echo 3. Chinese Tradionnal
echo 4. Japanese
echo 5. Korean
echo 6. WTF Where am I just let me leave

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
    echo JUST INPUT NUMBER !!!
    pause
    goto :language_menu
)

:: Start LeagueClient.exe with selected language.
start "" "%leagueClient_path%\LeagueClient.exe" "--locale=!language!"

:end
