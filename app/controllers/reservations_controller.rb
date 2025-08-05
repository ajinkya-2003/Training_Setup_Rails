class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant
  before_action :set_reservation, only: [:approve, :reject]
  before_action :authorize_staff!, only: [:index, :approve, :reject]

  def new
    @reservation = @restaurant.reservations.new
  end

  def create
    @reservation = @restaurant.reservations.new(reservation_params)
    @reservation.status = 'pending' # Initial status

    if @reservation.save
      flash[:notice] = 'Reservation request submitted! Awaiting confirmation.'

      if current_user.customer?
        redirect_to homepage_path
      else
        redirect_to restaurant_path(@restaurant)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @reservations = @restaurant.reservations.order(reservation_date: :asc, reservation_time: :asc)
  end

  def approve
    begin
      @reservation.accept!
      ReservationMailer.confirmation_email(@reservation).deliver_now
      flash[:notice] = 'Reservation approved and customer notified.'
    rescue AASM::InvalidTransition
      flash[:alert] = 'Failed to approve reservation. Invalid state transition.'
    end
    redirect_to restaurant_reservations_path(@restaurant)
  end

  def reject
    begin
      @reservation.reject!
      ReservationMailer.rejection_email(@reservation).deliver_now
      flash[:notice] = 'Reservation rejected and customer notified.'
    rescue AASM::InvalidTransition
      flash[:alert] = 'Failed to reject reservation. Invalid state transition.'
    end
    redirect_to restaurant_reservations_path(@restaurant)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_reservation
    @reservation = @restaurant.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(
      :reservation_date, :reservation_time,
      :number_of_guests, :customer_name, :customer_contact
    )
  end

  def authorize_staff!
    unless current_user.staff?
      flash[:alert] = 'You are not authorized to access this page.'
      redirect_to homepage_path
    end
  end
end
