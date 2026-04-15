# PocketPact Plaid Integration Setup Script
# This script will guide you through the complete setup process

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host " PocketPact Plaid Integration Setup " -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
$nodeInstalled = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeInstalled) {
    Write-Host "[ERROR] Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

$nodeVersion = node --version
Write-Host "[OK] Node.js installed: $nodeVersion" -ForegroundColor Green
Write-Host ""

# Step 1: Get Plaid Credentials
Write-Host "STEP 1: Get Plaid Credentials" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open: https://dashboard.plaid.com/signup" -ForegroundColor White
Write-Host "2. Sign up for a FREE Plaid account" -ForegroundColor White
Write-Host "3. Go to: Team Settings -> Keys" -ForegroundColor White
Write-Host "4. Copy your client_id and sandbox secret" -ForegroundColor White
Write-Host ""
$continue = Read-Host "Have you copied your credentials? (y/n)"

if ($continue -ne "y") {
    Write-Host ""
    Write-Host "Come back when you have your credentials!" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "STEP 2: Install Backend Dependencies" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host ""

Set-Location backend

Write-Host "Installing npm packages..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Dependencies installed!" -ForegroundColor Green
Write-Host ""

# Step 3: Configure .env
Write-Host "STEP 3: Configure Environment" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor Yellow
Write-Host ""

if (Test-Path .env) {
    Write-Host "[WARNING] .env file already exists!" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite it? (y/n)"
    if ($overwrite -ne "y") {
        Write-Host "[INFO] Keeping existing .env file" -ForegroundColor Cyan
    } else {
        Copy-Item .env.example .env -Force
        Write-Host "[OK] Created new .env file" -ForegroundColor Green
    }
} else {
    Copy-Item .env.example .env
    Write-Host "[OK] Created .env file" -ForegroundColor Green
}

Write-Host ""
Write-Host "Enter your Plaid credentials:" -ForegroundColor Cyan
Write-Host ""
$clientId = Read-Host "Plaid CLIENT_ID"
$secret = Read-Host "Plaid SANDBOX SECRET"

# Update .env file
$envContent = Get-Content .env
$envContent = $envContent -replace 'PLAID_CLIENT_ID=.*', "PLAID_CLIENT_ID=$clientId"
$envContent = $envContent -replace 'PLAID_SECRET=.*', "PLAID_SECRET=$secret"
$envContent | Set-Content .env

Write-Host "[OK] Credentials saved to .env" -ForegroundColor Green
Write-Host ""

# Step 4: Update Flutter config
Write-Host "STEP 4: Update Flutter Configuration" -ForegroundColor Yellow  
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host ""

Set-Location ..

$plaidConfigPath = "lib\config\plaid_config.dart"
$configContent = Get-Content $plaidConfigPath -Raw
$configContent = $configContent -replace "static const String clientId = '.*';", "static const String clientId = '$clientId';"
$configContent | Set-Content $plaidConfigPath

Write-Host "[OK] Updated Flutter PlaidConfig" -ForegroundColor Green
Write-Host ""

# Setup Complete
Write-Host "========================================" -ForegroundColor Green
Write-Host "         SETUP COMPLETE!                " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. START BACKEND SERVER:" -ForegroundColor Yellow
Write-Host "   cd backend" -ForegroundColor White
Write-Host "   npm start" -ForegroundColor White
Write-Host ""
Write-Host "2. RUN FLUTTER APP (new terminal):" -ForegroundColor Yellow
Write-Host "   flutter run -d emulator-5554" -ForegroundColor White
Write-Host ""
Write-Host "3. TEST IN APP:" -ForegroundColor Yellow
Write-Host "   Settings -> Link Bank Account" -ForegroundColor White
Write-Host "   Bank: First Platypus Bank" -ForegroundColor White
Write-Host "   Username: user_good" -ForegroundColor White
Write-Host "   Password: pass_good" -ForegroundColor White
Write-Host ""
Write-Host "Full Guide: PLAID_SETUP.md" -ForegroundColor Cyan
Write-Host ""

$startBackend = Read-Host "Start backend server now? (y/n)"

if ($startBackend -eq "y") {
    Write-Host ""
    Write-Host "Starting backend server..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    Set-Location backend
    npm start
}
