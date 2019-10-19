class ReservationPlanFloorPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :reservation_plan
  belongs_to :floor_plan
end
