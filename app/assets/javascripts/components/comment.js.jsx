var Comment = React.createClass({
    propTypes: {
        author: React.PropTypes.string,
        body: React.PropTypes.string
    },
    render: function() {
        return (
            <div className='comment'>
                <p className='author'><q>Author: {this.props.author}</q></p>
                <p className='body'>{this.props.body}</p>
            </div>
        );
    }
});