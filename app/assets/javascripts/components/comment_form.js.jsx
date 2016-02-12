var CommentForm = React.createClass({
    handleSubmit: function() {
        var comment = this.refs.body.getDOMNode().value.trim();
        this.props.onCommentSubmit({body: comment});
        this.refs.body.getDOMNode().value = '';
        return false;
    },
    render: function() {
        return (
            <div className='row'>
                <form className='commentForm' onSubmit={this.handleSubmit}>
                    <input type='text' placeholder='Say something...' ref='body' />
                    <input type='submit' value='Post' className='button' />
                </form>
            </div>
        );
    }
});