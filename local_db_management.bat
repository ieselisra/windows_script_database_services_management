rem Basic Script to launch or stop Database Services
rem from Windows PowerShell

rem You can add or modify services as needed

rem This script should be launched from a window with Administrator privileges

rem Author: Israel G. 

@echo off

rem Define variables
set "serviceMaria=MariaDB"
set "serviceSql=MySQL57"


:check_status
echo --------
rem Check service status
sc query "%serviceMaria%" | find "RUNNING" >nul && set "mariaRunning=1" || set "mariaRunning=0"
sc query "%serviceSql%" | find "RUNNING" >nul && set "sqlRunning=1" || set "sqlRunning=0"

echo      Service Status:
echo                %serviceMaria% is %mariaRunning%
echo                %serviceSql% is %sqlRunning%
echo --------

:menu
echo Select an option:
echo    1. Stop %serviceMaria%
echo    2. Start %serviceMaria%
echo    3. Stop %serviceSql%
echo    4. Start %serviceSql%
echo    5. Stop both (%serviceMaria% / %serviceSql%)
echo    6. Switch Service
echo    0. Exit
echo --------

set /p opcion=Insert option:
echo --------


rem Check option
if %opcion% equ 1 (
    net stop %serviceMaria%
) else if %opcion% equ 2 (
    net start %serviceMaria%
) else if %opcion% equ 3 (
    net stop %serviceSql%
) else if %opcion% equ 4 (
    net start %serviceSql%
) else if %opcion% equ 5 (
    net stop %serviceMaria%
    net stop %serviceSql%
) else if %opcion% equ 6 (
    rem Check if both services are stopped
    if %mariaRunning% equ 0 if %sqlRunning% equ 0 (
        echo                There's no service started.
        echo --------
        goto check_status
    )

    if %mariaRunning% equ 1 (
        net stop %serviceMaria%
        net start %serviceSql%
    ) else (
        net stop %serviceSql%
        net start %serviceMaria%
    )
) else if %opcion% equ 0 (
    echo Bye!
    echo ----
    exit
) else (
    echo                Non valid option!
)

echo --------
goto check_status
