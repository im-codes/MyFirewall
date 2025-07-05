#Set Execution Policy to the instance
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
function NonactiveUpdate {
    Write-Output "# Nonactivating Windows Update..."

    # Stop and disable service
    Write-Output "- Stoping and disabling service"
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Set-Service -Name wuauserv -StartupType Disabled

    # - Block conection on Firewall
    Write-Output "- Blocking conection on Firewall"
    if (-not (Get-NetFirewallRule -DisplayName "Block_WindowsUpdate" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "Block_WindowsUpdate" `
            -Direction Outbound `
            -RemoteAddress 20.190.128.0/18, 40.126.0.0/18 `
            -Action Block `
            -Profile Any `
            -Description "Block Windows Update Server"
    }
    

    # Nonactiving automatic windows update on registry
    Write-Output "- Nonactiving automatic windows update on registry"
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
        -Name "NoAutoUpdate" -Value 1 -Type DWord

    Write-Output "@ Windows Update Succesfully Nonactivated."
}

function ActiveUpdate {
    Write-Output "# Activing Windows Update..."

    # Set service to manual and start it
    Write-Output "- Set service to manual and start it"
    Set-Service -Name wuauserv -StartupType Manual
    Start-Service -Name wuauserv

    # Deleting Firewall rule if excist
    Write-Output "- Deleting Firewall rule if excist"
    if (Get-NetFirewallRule -DisplayName "Block_WindowsUpdate" -ErrorAction SilentlyContinue) {
        Remove-NetFirewallRule -DisplayName "Block_WindowsUpdate"
    }

    # Activing automatic windows update on registry
    Write-Output "- Activing automatic windows update on registry"
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
        -Name "NoAutoUpdate" -ErrorAction SilentlyContinue

    Write-Output "@ Windows Update Succesfully Activated." 
    
}

function Show-Menu {
    #Clear-Host
    Write-Host "========== Windows Update Controller ==========" -ForegroundColor Cyan
    Write-Host "1. Nonactivate Windows Update"
    Write-Host "2. Activate Windows Update"
    Write-Host "0. Exit"
    Write-Host "==============================================="

    $choice = Read-Host "Enter The Command:"
    switch ($choice) {
        '1' { NonactiveUpdate; Pause; Show-Menu }
        '2' { ActiveUpdate; Pause; Show-Menu }
        '0' { Write-Host "Exit..."; exit }
        default {
            Write-Host "Unvalid Command. Retry." -ForegroundColor Red
            Pause
            Show-Menu
        }        
    }
}

# Show menu function
Show-Menu
