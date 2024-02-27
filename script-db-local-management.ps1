# SCript with GUI to manage DB service
# Author Israel G.

# Load assembly
Add-Type -AssemblyName System.Windows.Forms

# ButtonClick manager
function Button_Click {
    param (
        [System.Windows.Forms.Button]$button
    )

    switch ($button.Name) {
        "btnMariaDB" {
            StartStopService $serviceMaria
        }
        "btnMySQL" {
            StartStopService $serviceSql
        }
        "btnStopBoth" {
            StopBothServices
        }
        "btnSwitch" {
            SwitchService
        }
        "btnExit" {
            ExitScript
        }
    }
}

# Start or stop service
function StartStopService {
    param (
        [string]$serviceName
    )

    $serviceStatus = (Get-Service -Name $serviceName).Status

    # Verificar si el otro servicio está en ejecución
    $otherServiceName = if ($serviceName -eq $serviceMaria) { $serviceSql } else { $serviceMaria }
    $otherServiceStatus = (Get-Service -Name $otherServiceName).Status

    if ($serviceStatus -eq 'Running') {
        Stop-Service -Name $serviceName
        ShowMessageBox "$serviceName stopped"
    } elseif ($otherServiceStatus -eq 'Running') {
        ShowMessageBox "To launch $serviceName you must to stop $otherServiceName first"
    } else {
        Start-Service -Name $serviceName
        ShowMessageBox "$serviceName started"
    }

    UpdateStatusLabels
}

# Stop all services
function StopBothServices {
    Stop-Service -Name $serviceMaria
    Stop-Service -Name $serviceSql
    ShowMessageBox "Both services were stopped"
    UpdateStatusLabels
}

# Services Manager
function SwitchService {
    # Update services status
    $mariaRunning = (Get-Service -Name $serviceMaria).Status -eq 'Running'
    $sqlRunning = (Get-Service -Name $serviceSql).Status -eq 'Running'

    if (-not $mariaRunning -and -not $sqlRunning) {
        ShowMessageBox "There's no service started."
        return
    }

    if ($mariaRunning) {
        Stop-Service -Name $serviceMaria
        Start-Service -Name $serviceSql
        ShowMessageBox "Services updated: $serviceMaria stopped, $serviceSql started."
    } else {
        Stop-Service -Name $serviceSql
        Start-Service -Name $serviceMaria
        ShowMessageBox "Services updated: $serviceSql stopped, $serviceMaria started."
    }

    UpdateStatusLabels
}

# Exit function
function ExitScript {
    ShowMessageBox "See ya!"
    $form.Close()
}

# Status labels updater
function UpdateStatusLabels {
    $mariaRunning = (Get-Service -Name $serviceMaria).Status -eq 'Running'
    $sqlRunning = (Get-Service -Name $serviceSql).Status -eq 'Running'

    $mariaStatusText = if ($mariaRunning) { "Running" } else { "Stopped" }
    $sqlStatusText = if ($sqlRunning) { "Running" } else { "Stopped" }

    $labelMaria.Text = "MariaDB: $mariaStatusText"
    $labelMySQL.Text = "MySQL57: $sqlStatusText"

    # Adjust width
    $labelMaria.Width = 200
    $labelMySQL.Width = 200
}

# Message popup
function ShowMessageBox {
    param (
        [string]$message
    )

    [System.Windows.Forms.MessageBox]::Show($message, "Info", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Define vars
$serviceMaria = "MariaDB"
$serviceSql = "MySQL57"

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Database Services Control"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Create service status labels
$labelMaria = New-Object System.Windows.Forms.Label
$labelMaria.Text = "MariaDB: "
$labelMaria.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($labelMaria)

$labelMySQL = New-Object System.Windows.Forms.Label
$labelMySQL.Text = "MySQL57: "
$labelMySQL.Location = New-Object System.Drawing.Point(10, 50)
$form.Controls.Add($labelMySQL)

# Create buttons
$buttonNames = @("MariaDB", "MySQL", "StopBoth", "Switch", "Exit")
$buttonLocations = @(150, 80, 110, 220, 300)

for ($i = 0; $i -lt $buttonNames.Count; $i++) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $buttonNames[$i]
    $button.Name = "btn$($buttonNames[$i])"
    $button.Location = New-Object System.Drawing.Point($buttonLocations[$i], 120)
    $button.Size = New-Object System.Drawing.Size(80, 30)
    $button.Add_Click({ Button_Click $this })
    $form.Controls.Add($button)
}

# Show the form
UpdateStatusLabels
$form.ShowDialog()
