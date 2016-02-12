class CommentsController < ApplicationController
    before_action :authenticate_user!, except: :index
    before_action :pet_find, only: [:index, :create]
    before_action :comment_find, except: [:index, :create]

    respond_to :js
    authorize_resource

    def index
        respond_with(@comments = ActiveModel::ArraySerializer.new(@pet.comments.includes(:user).with_id.order(id: :desc), each_serializer: CommentSerializer).to_json)
    end

    def create
        @comment = @pet.comments.create(comment_params.merge(user: current_user))
        render nothing: true
    end

    def update
        @comment.update(comment_params) if @comment.user_id == current_user.id || current_user.admin
        respond_with @comment
    end

    def destroy
        if @comment.user_id == current_user.id || current_user.admin
            respond_with(@comment.destroy)
        else
            render nothing: true
        end
    end

    private
    def pet_find
        @pet = Pet.find(params[:pet_id])
    end

    def comment_find
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end
