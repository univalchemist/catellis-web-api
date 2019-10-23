class FloorPlanTable < ApplicationRecord
  acts_as_paranoid

  belongs_to :floor_plan
  has_many :reservations

  scope :table_type, -> (type) { where(table_type: type) }
  scope :table_shape, -> (shape) { where(table_shape: shape) }
  scope :not_blocked, -> { where(blocked: false) }

  enum table_shape: {
    rectangle: 0,
    circle: 1,
    bar: 2
  }, _prefix: :table_shape

  enum table_type: {
    indoor: 0,
    communal: 1,
    bar: 2,
    outdoor: 3,
    outdoor_bar: 4,
    hightop: 5,
    counter: 6,
    chefs_table: 7
  }, _prefix: :table_type

  validates_uniqueness_of(
    :table_number,
    scope: [:floor_plan_id, :deleted_at],
    case_sensitive: false
  )

  def restaurant
    floor_plan.restaurant
  end

  def can_combine?(table)
  end

  def get_tables_can_combine_with
  
  end

end
