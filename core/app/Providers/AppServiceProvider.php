<?php

namespace App\Providers;

use Illuminate\{
    Support\ServiceProvider,
    Support\Facades\DB
};
use Illuminate\Pagination\Paginator;

class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        view()->composer('*', function ($view) {
            $view->with('setting', (object)[
                'cookie_text' => 'This is a demo cookie text.',
            ]);
        });

        if (!file_exists('core/storage/installed') && !request()->is('install') && !request()->is('install/*')) {
         
            header("Location: install/");
            exit;
        }
    }
}
