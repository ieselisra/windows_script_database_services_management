# Basic Script to launch or stop Database Services
# from Windows PowerShell

# You can add or modify services as needed

# This script should be launched from a window with Administrator privileges

# Author: Israel G.

# Define variables
$serviceMaria = "MariaDB"
$serviceSql = "MySQL57"



# Programm starts here
Do {
    Clear-Host

    # Check services status
    $mariaRunning = (Get-Service -Name $serviceMaria).Status <# -eq 'Running' #>
    $sqlRunning = (Get-Service -Name $serviceSql).Status <# -eq 'Running' #>

    Write-Host "Select an option:"
    
    Write-Host "   1. Start/Stop $serviceMaria ($mariaRunning)"
    Write-Host "   2. Start/Stop $serviceSql ($sqlRunning)"
    
    Write-Host "   3. Stop both ($serviceMaria / $serviceSql)"

    Write-Host "   4. Switch Service"
    Write-Host "   0. Exit"
    Write-Host "--------"

    $opcion = Read-Host "Insert option"
    Write-Host "--------"

    # Check option
    switch ($opcion) {
        1 {
            if ($mariaRunning -eq 'Running') {
                Stop-Service -Name $serviceMaria
            } else {
                Start-Service -Name $serviceMaria
            }
        }
        2 {
            if ($sqlRunning -eq 'Running') {
                Stop-Service -Name $serviceSql
            } else {
                Start-Service -Name $serviceSql
            }
        }
        3 {
            Stop-Service -Name $serviceMaria
            Stop-Service -Name $serviceSql
        }
        4 {
            # Check if both services are stopped
            if (-not $mariaRunning -and -not $sqlRunning) {
                Write-Host "               There's no service started."
                Write-Host "--------"
                Check-Status
                continue
            }

            if ($mariaRunning) {
                Stop-Service -Name $serviceMaria
                Start-Service -Name $serviceSql
            } else {
                Stop-Service -Name $serviceSql
                Start-Service -Name $serviceMaria
            }
        }
        0 {
            Write-Host "Bye!"
            Write-Host "----"
            exit
        }
        default {
            Write-Host "               Non valid option!"
        }
    }

} while ($true)
