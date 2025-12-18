@echo off
echo ========================================
echo Starting OmniMart Development Server
echo ========================================
echo.

REM Change to script directory
cd /d "%~dp0"

echo Current directory: %CD%
echo.

echo Checking PHP...
php --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: PHP is not found in PATH!
    echo Please make sure PHP is installed and added to PATH
    pause
    exit /b 1
)

if not exist "index.php" (
    echo ERROR: index.php file not found in: %CD%
    echo Please make sure you're running this script from the project root directory
    pause
    exit /b 1
)

echo Found index.php: %CD%\index.php
echo.
echo Server will start on: http://127.0.0.1:8000
echo Press Ctrl+C to stop the server
echo.

REM Check if router.php exists
if not exist "router.php" (
    echo Creating router.php...
    (
        echo ^<?php
        echo $uri = urldecode^(parse_url^($_SERVER['REQUEST_URI'], PHP_URL_PATH^) ?? ''^);
        echo $publicPath = __DIR__;
        echo if ^($uri !== '/' ^&^& $uri !== '' ^&^& file_exists^($publicPath . $uri^) ^&^& !is_dir^($publicPath . $uri^)^) {
        echo     return false;
        echo }
        echo require_once $publicPath . '/index.php';
    ) > router.php
)

echo Using router: %CD%\router.php
echo.

REM Start PHP server with router script
php -S 127.0.0.1:8000 -t "%CD%" "%CD%\router.php"

pause

