# windows_script_database_services_management
Simple script to launch and stop database related services (MariaDB and MySQL57) from a PowerShell

>The script should be launched from a PowerShell window with Administrator privileges

# Configuration
By default, the script controls the status of MariaDB and MySql57 services.

You can modify this variables as needed, or add your own if you want to adapt the code or options to you context

>set "serviceMaria=MariaDB"
>
>set "serviceSql=MySQL57"