$(function(){
    // Адрес публикации комментария
    ls.comments.options.type.topic = {
        url_add: 		aRouter.guestcomments+'ajaxaddcomment/',
        url_response: 	aRouter.guestcomments+'ajaxresponsecomment/'
    };

    // Предпросмотр комментария
    ls.comments.preview = function(divPreview) {
        if ($("#form_comment_text").val() == '') return;
        $("#comment_preview_" + this.iCurrentShowFormComment).remove();
        $('#reply').before('<div id="comment_preview_' + this.iCurrentShowFormComment +'" class="comment-preview text"></div>');
        ls.tools.textPreview('form_comment_text', true, 'comment_preview_' + this.iCurrentShowFormComment);
    };

});
