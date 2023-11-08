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
:: Last Update: KST 2023-11-08 5:00 PM
:: Update log: Change remark from REM to ::

@ECHO OFF
:: Start of Title set.

title League of Legends Manual Language Selector

:: End of Title set.

@echo off
setlocal enabledelayedexpansion

:: Set Where leagueClient info file is gonna save.
set "leagueClient_info_file=%userprofile%\leagueClient_info.txt"

:: Check leagueClient_Info.txt exist. If not, then let user manualy input.
if not exist "%leagueClient_info_file%" (
    echo Please manual input leagueClient directory *no exe only directory*
    set /p "leagueClient_path="
    echo !leagueClient_path!> "%leagueClient_info_file%"
) else (
    REM From Saved file to read leagueClient Directory.
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