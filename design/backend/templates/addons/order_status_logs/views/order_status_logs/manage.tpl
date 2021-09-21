{** Order status logs section **}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" id="order_status_logs_form" name="order_status_logs_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_contents_order_status_logs"}

{$c_url=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

{$rev=$smarty.request.content_id|default:"pagination_contents_order_status_logs"}
{$c_icon="<i class=\"icon-`$search.sort_order_rev`\"></i>"}
{$c_dummy="<i class=\"icon-dummy\"></i>"}
{$order_status_descr = $smarty.const.STATUSES_ORDER|fn_get_simple_statuses:true:true}

{if $order_status_logs}
    <div class="table-responsive-wrapper">
        <table class="table table-middle table--relative table-responsive">
        <thead>
        <tr>
            <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=order&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("order")}{if $search.sort_by == "order"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th width="30%"><a class="cm-ajax" href="{"`$c_url`&sort_by=user&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("user")}{if $search.sort_by == "user"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=status_from&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status_from")}{if $search.sort_by == "status_from"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=status_to&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status_to")}{if $search.sort_by == "status_to"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th width="20%"><a class="cm-ajax" href="{"`$c_url`&sort_by=date&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("date")}{if $search.sort_by == "date"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
        </tr>
        </thead>
        {foreach from=$order_status_logs item=log}
        <tr class="cm-row-status-lower" >
            <td class="nowrap" data-th="{__("order")}">
                <a href="{"orders.details?order_id=`$log.order_id`"|fn_url}" class="underlined">{__("order")} <bdi>#{$log.order_id}</bdi></a>
            </td>
            <td class="nowrap" data-th="{__("user")}">
                {if $log.firstname || $log.lastname}
                    <a href="{"profiles.update?user_id=`$log.user_id`"|fn_url}">{$log.lastname} {$log.firstname}</a>
                {else}
                    -
                {/if}
            </td>
            <td class="nowrap" data-th="{__("status_from")}">
                <span class="label order-status o-status-{$log.status_from|strtolower}">{$order_status_descr[$log.status_from]}</span>
            </td>
            <td class="nowrap" data-th="{__("status_to")}">
                <span class="label order-status o-status-{$log.status_to|strtolower}">{$order_status_descr[$log.status_to]}</span>
            </td>
            <td class="nowrap" data-th="{__("date")}">
                {$log.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
            </td>
        </tr>
        {/foreach}
        </table>
    </div>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_contents_order_status_logs"}
</form>
{/capture}

{include file="common/mainbox.tpl" title=__("order_status_logs") content=$smarty.capture.mainbox}