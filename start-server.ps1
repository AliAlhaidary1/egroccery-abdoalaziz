# Laravel Development Server Starter (from root directory)
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting OmniMart Development Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to script directory (root of project)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "Current directory: $scriptPath" -ForegroundColor Gray
Write-Host ""

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

# Check if index.php exists
$indexPath = Join-Path $scriptPath "index.php"
if (-not (Test-Path $indexPath)) {
    Write-Host "ERROR: index.php file not found at: $indexPath" -ForegroundColor Red
    Write-Host "Please make sure you're running this script from the project root directory" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Found index.php: $indexPath" -ForegroundColor Green
Write-Host ""
Write-Host "Server will start on: http://127.0.0.1:8000" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Check if router.php exists, if not create it
$routerPath = Join-Path $scriptPath "router.php"
if (-not (Test-Path $routerPath)) {
    Write-Host "Creating router.php..." -ForegroundColor Yellow
    @"
<?php
`$uri = urldecode(parse_url(`$_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '');
`$publicPath = __DIR__;
if (`$uri !== '/' && `$uri !== '' && file_exists(`$publicPath . `$uri) && !is_dir(`$publicPath . `$uri)) {
    return false;
}
require_once `$publicPath . '/index.php';
"@ | Out-File -FilePath $routerPath -Encoding UTF8
}

Write-Host "Using router: $routerPath" -ForegroundColor Gray
Write-Host ""

# Start PHP built-in server with router script
php -S 127.0.0.1:8000 -t "$scriptPath" "$routerPath"

