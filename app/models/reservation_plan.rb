class ReservationPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :restaurant
  has_many :reservation_plan_floor_plans, dependent: :destroy
  has_many :floor_plans, through: :reservation_plan_floor_plans
  accepts_nested_attributes_for :reservation_plan_floor_plans, allow_destroy: true

  enum repeat: {
    none: 0,
    annually: 1,
  }, _prefix: :repeat
end
