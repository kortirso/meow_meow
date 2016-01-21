class PetsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :pet_find, only: [:show, :update, :destroy]

    def index
        @pets = Pet.all
    end

    def show

    end

    def new
        @pet = Pet.new
    end

    def create
        @pet = Pet.new(pet_params.merge(user: current_user))
        if @pet.save
            redirect_to @pet
        else
            render :new
        end
    end

    def update
         if @pet.user_id == current_user.id
            if @pet.update(country_params)
                redirect_to @pet
            else
                render :edit
            end
        end
    end

    def destroy
        @pet.destroy if @pet.user_id == current_user.id
        redirect_to pets_url
    end

    private
    def pet_find
        @pet = Pet.find(params[:id])
    end

    def pet_params
        params.require(:pet).permit(:name, :caption)
    end
end
