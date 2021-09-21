<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Gets order status logs list by search params
 *
 * @param array  $params         Logs search params
 * @param string $lang_code      2 letters language code
 * @param int    $items_per_page Items per page
 *
 * @return array Logs list and Search params
 */
function fn_order_status_logs_get_logs($params = array(), $lang_code = CART_LANGUAGE, $items_per_page = 0)
{
    // Set default values to input params
    $default_params = array(
        'page' => 1,
        'items_per_page' => $items_per_page
    );

    $params = array_merge($default_params, $params);

    $sortings = array(
        'order' => '?:order_status_logs.order_id',
        'user' => '?:order_status_logs.user_id',
        'status_from' => '?:order_status_logs.status_from',
        'status_to' => '?:order_status_logs.status_to',
        'date' => '?:order_status_logs.timestamp',
    );

    $condition = $limit = $join = '';

    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }

    $sorting = db_sort($params, $sortings, 'timestamp', 'asc');

    // if (!empty($params['item_ids'])) {
    //     $condition .= db_quote(' AND ?:order_status_logs.log_id IN (?n)', explode(',', $params['item_ids']));
    // }

    $fields = array (
        '?:order_status_logs.log_id',
        '?:order_status_logs.order_id',
        '?:order_status_logs.user_id',
        '?:order_status_logs.status_from',
        '?:order_status_logs.status_to',
        '?:order_status_logs.timestamp',
        '?:users.firstname',
        '?:users.lastname',
    );

    $join .= db_quote(' LEFT JOIN ?:users ON ?:users.user_id = ?:order_status_logs.user_id ');

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:order_status_logs $join WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $order_status_logs = db_get_array(
        "SELECT ?p FROM ?:order_status_logs " .
        $join .
        "WHERE 1 ?p ?p ?p",
        implode(', ', $fields), $condition, $sorting, $limit
    );

    return array($order_status_logs, $params);
}


//HOOKS
function fn_order_status_logs_change_order_status($status_to, $status_from, $order_info, $force_notification, $order_statuses, $place_order)
{
    $auth = & Tygh::$app['session']['auth'];
    $data = array(
        'order_id' => $order_info['order_id'],
        'user_id' => $auth['user_id'] ?? 0,
        'status_from' => $status_from,
        'status_to' => $status_to,
        'timestamp' => TIME,
    );

    db_query("INSERT INTO ?:order_status_logs ?e", $data);
}
