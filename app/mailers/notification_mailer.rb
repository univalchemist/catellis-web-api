class NotificationMailer < ApplicationMailer
  default :from => 'noreply@catellis.com'

  def send_inhouse_confirmation_email(restaurant, customer, result)
    @customer = customer
    @restaurant = restaurant
    @reservation = result.reservation

    mail( :to => @customer.email,
    :subject => "Thanks for your reservation" )
  end

  def send_confirmation_email(restaurant, customer, result)
    @customer = customer
    @restaurant = restaurant
    @reservation = result.reservation

    mail( :to => @customer.email,
    :subject => "Thanks for your reservation" )
  end

  def send_creation_reservation_alert_email(resturant, customer, result)
    @customer = customer
    @resturant = resturant
    @reservation = result.reservation

    mail( :to => @resturant.notification_email_address,
    :subject => "Reservation Created: #{@reservation.scheduled_start_at.in_time_zone(@resturant.timezone_name).strftime("%B %e, %Y %I:%M%P")}"  )
  end

  def send_edit_reservation_alert_email(restaurant, reservation, changes)
    @restaurant = restaurant
    @reservation = reservation
    @customer = Customer.find_by(id: reservation.customer_id)
    @changes = changes

    mail( :to => @restaurant.notification_email_address,
    :subject => "Reservation Edited: #{@customer.name}"  )
  end

  def send_cancelled_reservation_alert_email(restaurant, reservation)
    @restaurant = restaurant
    @reservation = reservation
    @customer = Customer.find_by(id: reservation.customer_id)

    mail( :to => @restaurant.notification_email_address,
    :subject => "Reservation Cancelled"  )
  end
end
