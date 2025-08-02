class MenuItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_menu_item, only: [:edit, :update, :destroy]

  def index
    @menu_items = @restaurant.menu_items
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = @restaurant.menu_items.build(menu_item_params)
    if @menu_item.save
      redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item added.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to restaurant_menu_path(@restaurant), notice: 'Menu item removed.'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = @restaurant.menu_items.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:item_name, :description, :price, :category, :available)
  end
end
