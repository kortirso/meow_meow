class Api::V1::CommentsController < Api::V1::BaseController
    authorize_resource Comment

    before_action :pet_find, only: [:index, :create]

    def index
        @comments = @pet.comments
        respond_with @comments
    end

    def show
        @comment = Comment.find(params[:id])
        respond_with @comment, serializer: CommentSerializer
    end

    def create
        @comment = @pet.comments.create(comment_params.merge(user: current_resource_owner))
        respond_with @comment, location: -> { api_v1_pet_comment_path(@pet, @comment) }
    end

    private
    def pet_find
        @pet = Pet.find(params[:pet_id])
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end