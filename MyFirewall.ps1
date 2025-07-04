function Disable-WindowsUpdate {
    Write-Host "`n🔧 Menonaktifkan Windows Update..." -ForegroundColor Yellow

    # Hentikan dan disable service
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Set-Service -Name wuauserv -StartupType Disabled

    # Blokir koneksi update via firewall
    if (-not (Get-NetFirewallRule -DisplayName "Block_WindowsUpdate" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "Block_WindowsUpdate" `
            -Direction Outbound `
            -RemoteAddress 20.190.128.0/18, 40.126.0.0/18 `
            -Action Block `
            -Profile Any `
            -Description "Blokir akses ke server Windows Update"
    }

    # Nonaktifkan update otomatis via registry
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
        -Name "NoAutoUpdate" -Value 1 -Type DWord

    Write-Host "✅ Windows Update berhasil dinonaktifkan.`n" -ForegroundColor Green
}

function Show-Menu {
    Clear-Host
    Write-Host "========== Windows Update Controller ==========" -ForegroundColor Cyan
    Write-Host "1. Nonaktifkan Windows Update"
    Write-Host "2. Aktifkan Windows Update"
    Write-Host "0. Keluar"
    Write-Host "==============================================="

    $choice = Read-Host "Masukkan pilihan Anda"
    switch ($choice) {
        '1' { Disable-WindowsUpdate; Pause; Show-Menu }
        '2' { Enable-WindowsUpdate; Pause; Show-Menu }
        '0' { Write-Host "Keluar..."; exit }
        default {
            Write-Host "Pilihan tidak valid. Coba lagi." -ForegroundColor Red
            Pause
            Show-Menu
        }
    }
}

# Jalankan menu saat script dibuka
Show-Menu
