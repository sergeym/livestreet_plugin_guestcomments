<?php

$config = array();

Config::Set('router.page.guestcomments','PluginGuestcomments_ActionGuestcomments');

$config['enabled'] = true; // true - разрешить публикацию гостевых коммантариев; false - запретить публикацию гостевых комментариев

return $config;
