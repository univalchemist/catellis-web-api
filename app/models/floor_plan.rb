class FloorPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :restaurant

  has_many :floor_plan_tables, dependent: :destroy
  has_many :reservation_plan_floor_plans, dependent: :destroy
  has_many :reservation_plans, through: :reservation_plan_floor_plans

  accepts_nested_attributes_for :floor_plan_tables, allow_destroy: true
end
