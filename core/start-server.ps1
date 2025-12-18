# Laravel Development Server Starter
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Laravel Development Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

# Check if PHP is available
try {
    $phpVersion = php --version 2>&1
    Write-Host "PHP Version: $($phpVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "ERROR: PHP is not found in PATH!" -ForegroundColor Red
    Write-Host "Please make sure PHP is installed and added to PATH" -ForegroundColor Yellow
    pause
    exit 1
}

# Check if artisan exists
if (-not (Test-Path "artisan")) {
    Write-Host "ERROR: artisan file not found!" -ForegroundColor Red
    Write-Host "Please run this script from the Laravel root directory" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "Server will start on: http://127.0.0.1:8000" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the server - change to parent directory first
Write-Host "Changing to project root..." -ForegroundColor Green
Set-Location ..

Write-Host "Starting PHP built-in server..." -ForegroundColor Green
php -S 127.0.0.1:8000 -t . index.php

