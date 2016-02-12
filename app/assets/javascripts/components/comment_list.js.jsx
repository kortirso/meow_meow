var CommentList = React.createClass({
    render: function() {
        return (
            <div className='row'>
                {
                    this.props.comments.map(function(comment) {
                        return <Comment key={comment.id} {... comment} />;
                    })
                }
            </div>
        );
    }
});