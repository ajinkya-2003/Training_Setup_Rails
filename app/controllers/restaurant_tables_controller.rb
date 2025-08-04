class RestaurantTablesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_table, only: [:edit, :update, :destroy]

  def index
    tables = @restaurant.restaurant_tables

    # Filter by status
    if params[:status].present? && params[:status] != "All"
      tables = tables.where(status: params[:status])
    end

    # Search by table_number
    if params[:search].present?
      tables = tables.where("CAST(table_number AS TEXT) ILIKE ?", "%#{params[:search]}%")
    end

    # Apply sorting
    tables = tables.order("#{sort_column} #{sort_direction}")

    # Paginate
    @tables = tables.paginate(page: params[:page], per_page: 5)

    # For new table modal
    @new_table = @restaurant.restaurant_tables.new
  end

  def create
    @table = @restaurant.restaurant_tables.new(table_params)

    if @table.save
      redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table added successfully.'
    else
      @tables = @restaurant.restaurant_tables.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
      @new_table = @table
      flash.now[:alert] = 'Failed to add table.'
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    # Renders edit.html.erb with @restaurant and @table set
  end

  def update
    if @table.update(table_params)
      redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table updated successfully.'
    else
      flash.now[:alert] = 'Failed to update table.'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @table.destroy
    redirect_to restaurant_restaurant_tables_path(@restaurant), notice: 'Table deleted successfully.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def set_table
    @table = @restaurant.restaurant_tables.find(params[:id])
  end

  def table_params
    params.require(:restaurant_table).permit(:table_number, :capacity, :status)
  end

  def sort_column
    %w[table_number capacity status created_at].include?(params[:sort]) ? params[:sort] : "table_number"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
