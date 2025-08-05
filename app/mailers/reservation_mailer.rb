class ReservationMailer < ApplicationMailer
  default from: 'no-reply@yourapp.com'

  def confirmation_email(reservation)
    @reservation = reservation
    mail(to: @reservation.customer_contact, subject: 'Your reservation is confirmed')
  end

  def rejection_email(reservation)
    @reservation = reservation
    mail(to: @reservation.customer_contact, subject: 'Your reservation was not approved')
  end
end
