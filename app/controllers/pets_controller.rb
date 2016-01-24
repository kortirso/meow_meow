class PetsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :pet_find, only: [:show, :edit, :update, :destroy]
    before_action :build_comment, only: :show

    respond_to :js, only: [:update, :destroy]
    authorize_resource

    def index
        respond_with(@pets = Pet.all)
    end

    def show
        respond_with @pet
    end

    def new
        respond_with(@pet = Pet.new)
    end

    def create
        respond_with(@pet = Pet.create(pet_params.merge(user: current_user)))
    end

    def edit
        respond_with @pet
    end

    def update
        @pet.update(pet_params) if @pet.user_id == current_user.id || current_user.admin
        respond_with @pet
    end

    def destroy
        if @pet.user_id == current_user.id || current_user.admin
            respond_with(@pet.destroy)
        else
            render nothing: true
        end
    end

    private
    def pet_find
        @pet = Pet.find(params[:id])
    end

    def build_comment
        @comment = @pet.comments.build
    end

    def pet_params
        params.require(:pet).permit(:name, :caption, :image)
    end
end
