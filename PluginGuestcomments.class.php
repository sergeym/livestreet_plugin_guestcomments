<?php

if (!class_exists('Plugin')) {
	die('Hacking attemp!');
}

class PluginGuestcomments extends Plugin {

	protected $aDelegates = array(
		'template' => array(
            'comment_tree.tpl' => '_comment_tree.tpl',
            'comment.tpl' => '_comment.tpl',
            'toolbar_comment.tpl' => '_toolbar_comment.tpl',
        ),
	);

	protected $aInherits = array(
		'mapper' => array('ModuleComment_MapperComment'),
		'entity' => array('ModuleComment_EntityComment')
    );
	
	/**
	 * Активация плагина
	 */
	public function Activate() {

        // создание гостя
        if( !$this->User_GetUserById(0) ) {
			$this->ExportSQL(dirname(__FILE__).'/create_guset_user.sql');
		}

        // создание дополнительных полей
        $prefix=Config::Get('db.table.prefix');
        // имя гостя
        if(!$this->isFieldExists($prefix.'comment','guest_name')) {
            $this->ExportSQLQuery("ALTER TABLE `{$prefix}comment` ADD `guest_name` varchar(150) DEFAULT NULL;");
        }
        // email гостя
        if(!$this->isFieldExists($prefix.'comment','guest_email')) {
            $this->ExportSQLQuery("ALTER TABLE `{$prefix}comment` ADD `guest_email` varchar(150) DEFAULT NULL;");
        }

		return true;
	}
	
	/**
	 * Инициализация плагина
	 */
	public function Init() {
	}
}
?>