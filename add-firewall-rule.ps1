# Add Windows Firewall Rule for PocketPact Backend Server
# Right-click this file and select "Run with PowerShell" (as Administrator)

Write-Host "Adding Windows Firewall rule for PocketPact Backend Server..." -ForegroundColor Cyan

try {
    New-NetFirewallRule -DisplayName "PocketPact Backend Server" `
                        -Direction Inbound `
                        -Protocol TCP `
                        -LocalPort 3000 `
                        -Action Allow `
                        -ErrorAction Stop
    
    Write-Host "✅ Firewall rule added successfully!" -ForegroundColor Green
    Write-Host "Port 3000 is now accessible from Android emulator" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please make sure you run this script as Administrator" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
