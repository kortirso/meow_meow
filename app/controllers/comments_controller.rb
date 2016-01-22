class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :pet_find, only: :create
    before_action :comment_find, except: :create

    respond_to :js
    authorize_resource

    def create
        @comment = @pet.comments.create(comment_params.merge(user: current_user))
    end

    def update
        @comment.update(comment_params) if @comment.user_id == current_user.id
        respond_with @comment
    end

    def destroy
        @comment.user_id == current_user.id ? respond_with(@comment.destroy) : respond_with(@comment)
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
