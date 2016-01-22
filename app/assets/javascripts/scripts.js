$(function() {
    $('#comments').on('click', '.edit_comment_btn', function(e) {
        e.preventDefault();
        var clickId = this.id;
        $('form#edit_comment_' + clickId).show();
        $(this).hide();
    });

    $('#comments').on('click', '.cancel_comment_answer', function(e) {
        e.preventDefault();
        $('.edit_comment').hide();
        $(this).parent('form').parent('.comment').children('.edit_comment_btn').show();
    });
})