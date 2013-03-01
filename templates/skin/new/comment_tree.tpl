{add_block group='toolbar' name='toolbar_comment.tpl'
	aPagingCmt=$aPagingCmt
	iTargetId=$iTargetId
	sTargetType=$sTargetType
	iMaxIdComment=$iMaxIdComment
}

{hook run='comment_tree_begin' iTargetId=$iTargetId sTargetType=$sTargetType}
{*
{if $oUserCurrent}
<script type="text/javascript">
	jQuery(document).ready(function($){
		$(document).click(function(){
			if (!$('#reply-top-form').is(':visible')) {
				$('#reply').hide();
				$('#reply-top-form').show();
			}
		});
		
		$('body').on('click', '#reply-top', function(e) {
			e.stopPropagation();
		});
	});
	
	ls.comments.expandReplyTop = function() {
		$('#reply').show().appendTo('#reply-top');
		$('#reply-top-form').hide();
		$('#form_comment_text').val('');
		$('#form_comment_reply').val(0);
	}
</script>
{/if}
*}

<div class="comments" id="comments">
	<header class="comments-header">
		<h3>{$aLang.comment_title} (<span id="count-comments">{$iCountComment}</span>)</h3>

		{if $bAllowSubscribe and $oUserCurrent}
			<div class="subscribe">
				<input {if $oSubscribeComment and $oSubscribeComment->getStatus()}checked="checked"{/if} type="checkbox" id="comment_subscribe" class="input-checkbox" onchange="ls.subscribe.toggle('{$sTargetType}_new_comment','{$iTargetId}','',this.checked);">
				<label for="comment_subscribe">{$aLang.comment_subscribe}</label>
			</div>
		{/if}
	
		<a name="comments"></a>
	</header>
	
	{*
	{if $oUserCurrent}
		<div id="reply-top">
			<div class="wall-submit wall-submit-reply wall-submit-comment" id="reply-top-form">
				<textarea rows="4" class="input-text input-width-full" placeholder="{$aLang.wall_reply_placeholder}" onclick="ls.comments.expandReplyTop();"></textarea>
			</div>
		</div>
	{/if}
	*}

	{assign var="nesting" value="-1"}
	{foreach from=$aComments item=oComment name=rublist}
		{assign var="cmtlevel" value=$oComment->getLevel()}
		
		{if $cmtlevel>$oConfig->GetValue('module.comment.max_tree')}
			{assign var="cmtlevel" value=$oConfig->GetValue('module.comment.max_tree')}
		{/if}
		
		{if $nesting < $cmtlevel} 
		{elseif $nesting > $cmtlevel}    	
			{section name=closelist1  loop=$nesting-$cmtlevel+1}</div>{/section}
		{elseif not $smarty.foreach.rublist.first}
			</div>
		{/if}
		
		<div class="comment-wrapper" id="comment_wrapper_id_{$oComment->getId()}">
		
		{include file='comment.tpl'} 
		{assign var="nesting" value=$cmtlevel}
		{if $smarty.foreach.rublist.last}
			{section name=closelist2 loop=$nesting+1}</div>{/section}    
		{/if}
	{/foreach}
</div>				
	
	
{include file='comment_paging.tpl' aPagingCmt=$aPagingCmt}

{hook run='comment_tree_end' iTargetId=$iTargetId sTargetType=$sTargetType}

{if $bAllowNewComment}
	{$sNoticeNotAllow}
{else}
	{if $oUserCurrent}

		{include file='editor.tpl' sImgToLoad='form_comment_text' sSettingsTinymce='ls.settings.getTinymceComment()' sSettingsMarkitup='ls.settings.getMarkitupComment()'}
	
		<h4 class="reply-header" id="comment_id_0">
			<a href="#" class="link-dotted" onclick="ls.comments.toggleCommentForm(0); return false;">{$sNoticeCommentAdd}</a>
		</h4>
		
		
		<div id="reply" class="reply">		
			<form method="post" id="form_comment" onsubmit="return false;" enctype="multipart/form-data">
				{hook run='form_add_comment_begin'}
				
				<textarea name="comment_text" id="form_comment_text" class="input-width-full"></textarea>
				
				{hook run='form_add_comment_end'}
				
				<button type="submit"  name="submit_comment" 
						id="comment-button-submit" 
						onclick="ls.comments.add('form_comment',{$iTargetId},'{$sTargetType}'); return false;" 
						class="button button-primary">{$aLang.comment_add}</button>
				<button type="button" onclick="ls.comments.preview();" class="button">{$aLang.comment_preview}</button>
				
				<input type="hidden" name="reply" value="0" id="form_comment_reply" />
				<input type="hidden" name="cmt_target_id" value="{$iTargetId}" />
			</form>
		</div>
	{else}
		{if $oConfig->GetValue('plugin.guestcomments.enabled')}

            <h4 class="reply-header" id="comment_id_0">
                <a href="#" class="link-dotted" onclick="ls.comments.toggleCommentForm(0); return false;">{$sNoticeCommentAdd}</a>
            </h4>

            <script type="text/javascript" src="{$aTemplateWebPathPlugin.guestcomments|cat:'js/'}guestcomments.js"></script>

            <script type="text/javascript">
                function updateCaptcha() {
                    if (document.commentCaptcha) {
                        document.commentCaptcha.src="{cfg name='path.root.engine_lib'}/external/kcaptcha/index.php?{$_sPhpSessionName}={$_sPhpSessionId}&n='+Math.random()";
                    }
                }
            </script>


            <div id="reply" class="reply">
                <form method="post" id="form_comment" onsubmit="return false;" enctype="multipart/form-data">
                    {hook run='form_add_comment_begin'}

                    <p>
                        <label for="guest_name">{$aLang.plugin.guestcomments.name}:</label>
                        <input type="text" class="input-text input-width-200" id="guest_name" name="guest_name" value="" autocomplete="on">
                    </p>

                    <p>
                        <label for="guest_email">{$aLang.plugin.guestcomments.mail}:</label>
                        <input type="text" class="input-text input-width-200" id="guest_email" name="guest_email" value="" autocomplete="on">
                    </p>

                    <textarea name="comment_text" id="form_comment_text" class="mce-editor markitup-editor input-width-full"></textarea>

                    {hook run='form_add_comment_end'}

                    <p>
                        <label for="captcha">{$aLang.plugin.guestcomments.captcha}:</label>
                        <img src="{cfg name='path.root.engine_lib'}/external/kcaptcha/index.php?{$_sPhpSessionName}={$_sPhpSessionId}" name="commentCaptcha" onclick="this.src='{cfg name='path.root.engine_lib'}/external/kcaptcha/index.php?{$_sPhpSessionName}={$_sPhpSessionId}&n='+Math.random();"><br>
                        <input type="text" class="input-text input-width-50" id="captcha" name="captcha" value="" maxlength=3 size=9>
                    </p>

                    <button type="submit"  name="submit_comment"
                            id="comment-button-submit"
                            onclick="ls.comments.add('form_comment',{$iTargetId},'{$sTargetType}'); return false;"
                            class="button button-primary">{$aLang.comment_add}</button>
                    <button type="button" onclick="ls.comments.preview();" class="button">{$aLang.comment_preview}</button>

                    <input type="hidden" name="reply" value="0" id="form_comment_reply" />
                    <input type="hidden" name="cmt_target_id" value="{$iTargetId}" />
                </form>
            </div>

        {else}
            {$aLang.comment_unregistered}<br />
        {/if}
	{/if}
{/if}	


