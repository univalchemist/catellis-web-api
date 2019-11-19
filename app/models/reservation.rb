class Reservation < ApplicationRecord
  acts_as_paranoid

  @@ACTIVE_STATUSES = %i[
    not_confirmed
    confirmed
    left_message
    no_answer
    wrong_number
    waitlist
    seated
  ]
  @@INACTIVE_STATUSES = %i[
    canceled_guest
    canceled_restaurant
    complete
  ]

  belongs_to :restaurant
  belongs_to :customer
  belongs_to :floor_plan_table, optional: true

  enum reservation_status: {
    not_confirmed: 0,
    confirmed: 1,
    left_message: 2,
    no_answer: 3,
    wrong_number: 4,
    canceled_guest: 5,
    canceled_restaurant: 6,
    complete: 7,
    waitlist: 8,
    seated: 9,
  }, _prefix: :reservation_status

  belongs_to :canceled_by, class_name: 'User', optional: true

  def cancel(type=:canceled_guest)
    update(reservation_status: type)
  end

  def canceled?
    reservation_status == "canceled_guest" ||
    reservation_status == "canceled_restaurant" ||
    reservation_status == "complete"
  end

  def local_scheduled_start_at
    local_timezone.utc_to_local(scheduled_start_at)
  end

  def local_scheduled_start_at_offset
    local_timezone.time_with_offset(scheduled_start_at)
  end

  def local_timezone
    restaurant.local_timezone
  end

  def active_status?
    Reservation.ACTIVE_STATUSES.include?(reservation_status.to_sym)
  end

  def inactive_status?
    Reservation.INACTIVE_STATUSES.include?(reservation_status.to_sym)
  end

  def self.ACTIVE_STATUSES
    @@ACTIVE_STATUSES
  end

  def self.INACTIVE_STATUSES
    @@INACTIVE_STATUSES
  end

  def is_time_during_reservation?(time)
    time.between?(scheduled_start_at, scheduled_end_at - 1.minute)
  end

  def is_time_during_reservation_or_lead_in_time?(time, new_party_size)
    new_party_turn_time = restaurant.send("turn_time_#{new_party_size}")
    time.between?(scheduled_start_at - new_party_turn_time.to_f.hours + 1.minute, scheduled_end_at - 1.minute)
  end

  def is_time_at_start?(time)
    scheduled_start_at == time
  end

  def earliest_accomodatable_time_for_party_size(size)
    new_party_turn_time = restaurant.send("turn_time_#{size}")
    scheduled_start_at - new_party_turn_time.to_f.hours
  end

  def get_ideal_tables(floor_plan)
    tables = floor_plan.floor_plan_tables
    tables.order(max_covers: :desc)
  end

  def turn_time
    if override_turn_time.nil?
      restaurant.send("turn_time_#{party_size}").to_f
    else
      override_turn_time
    end
  end
end
