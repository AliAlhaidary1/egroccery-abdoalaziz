<?php
/**
 * Router script for PHP built-in server
 * This file routes all requests to the Laravel application
 */

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '');

$publicPath = __DIR__;

// Serve static files directly if they exist
if ($uri !== '/' && $uri !== '' && file_exists($publicPath . $uri) && !is_dir($publicPath . $uri)) {
    return false;
}

// Route all other requests to public/index.php
require_once $publicPath . '/public/index.php';

