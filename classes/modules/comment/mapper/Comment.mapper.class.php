<?php

class PluginGuestcomments_ModuleComment_MapperComment extends PluginGuestcomments_Inherit_ModuleComment_MapperComment {
	
	public function AddComment(ModuleComment_EntityComment $oComment) {
	
		$sql = "INSERT INTO ".Config::Get('db.table.comment')." 
			(comment_pid,
			target_id,
			target_type,
			target_parent_id,
			user_id,
			comment_text,
			comment_date,
			comment_user_ip,
			comment_text_hash,
            guest_name,
            guest_email		
			)
			VALUES(?, ?d, ?, ?d, ?d, ?, ?, ?, ?, ?, ?)
		";			
		if ($iId=$this->oDb->query($sql,$oComment->getPid(),$oComment->getTargetId(),$oComment->getTargetType(),$oComment->getTargetParentId(),$oComment->getUserId(),$oComment->getText(),$oComment->getDate(),$oComment->getUserIp(),$oComment->getTextHash(),$oComment->getGuestName(),$oComment->getGuestEmail())) 
		{
			return $iId;
		}	
		return false;
	}
	
}