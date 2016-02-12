var CommentBox = React.createClass({
    getInitialState: function () {
        return {
            comments: [],
            user: []
        };
    },
    componentDidMount: function () {
        this.loadCommentsFromServer();
        this.setState({user: this.props.user});
    },
    loadCommentsFromServer: function () {
        $.ajax({
            url: this.props.url,
            dataType: 'json',
            success: function (comments) {
                this.setState({comments: comments});
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    handleCommentSubmit: function(comment) {
        var comments = this.state.comments;
        var newComments = comments.concat([comment]);
        this.setState({comments: newComments});
        $.ajax({
            url: this.props.url,
            dataType: 'json',
            type: 'POST',
            data: {'comment': comment},
            success: function(data) {
                this.loadCommentsFromServer();
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    renderWithUser: function() {
        return (
            <div className='commentBox'>
                <h2>Comments</h2>
                <CommentForm onCommentSubmit={this.handleCommentSubmit}/>
                <CommentList comments={this.state.comments} />
            </div>
        );
    },
    renderWithoutUser: function() {
        return (
            <div className='commentBox'>
                <h2>Comments</h2>
                <CommentList comments={this.state.comments} />
            </div>
        );
    },
    render: function () {
        if (this.state.user) {
            return this.renderWithUser();
        }
        else {
            return this.renderWithoutUser();
        }
    }
});