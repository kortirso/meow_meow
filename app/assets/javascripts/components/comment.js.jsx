var Comment = React.createClass({
    propTypes: {
        author: React.PropTypes.string,
        body: React.PropTypes.string
    },
    render: function() {
        return (
            <div>
                <p>User: {this.props.author}</p>
                <p>{this.props.body}</p>
            </div>
        );
    }
});