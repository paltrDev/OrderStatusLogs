<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD']	== 'POST') {

}

if ($mode == 'manage') {

    list($order_status_logs, $params) = fn_order_status_logs_get_logs($_REQUEST, DESCR_SL, Registry::get('settings.Appearance.admin_elements_per_page'));

    Tygh::$app['view']->assign(array(
        'order_status_logs'  => $order_status_logs,
        'search' => $params,
    ));
}
