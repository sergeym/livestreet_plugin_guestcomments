<?php

class PluginGuestcomments_ModuleComment_EntityComment extends PluginGuestcomments_Inherit_ModuleComment_EntityComment
{ 
    public function getGuestName() {
        return isset($this->_aData['guest_name'])?$this->_aData['guest_name']:null;
    }
    public function getGuestEmail() {
        return isset($this->_aData['guest_email'])?$this->_aData['guest_email']:null;
    }
    
    public function setGuestName($data) {
        $this->_aData['guest_name']=$data;
    }
    public function setGuestEmail($data) {
        $this->_aData['guest_email']=$data;
    }
}