class Api::V1::PetsController < Api::V1::BaseController
    authorize_resource Pet

    def index
        @pets = Pet.all
        respond_with @pets
    end

    def show
        @pet = Pet.find(params[:id])
        respond_with @pet, serializer: PetSerializer::Pet
    end

    def create
        @pet = current_resource_owner.pets.create(pet_params)
        respond_with @pet
    end

    private
    def pet_params
        params.require(:pet).permit(:name, :caption, :image)
    end
end