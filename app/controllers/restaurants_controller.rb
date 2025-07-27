class RestaurantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @restaurants = current_user.restaurants
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    @restaurant.status = :open

    if @restaurant.save
      redirect_to homepage_path, notice: 'Your Restaurant was created and is open for business.'
    else
      flash.now[:alert] = 'Please fix the errors below.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :cuisine_type)
  end
end
