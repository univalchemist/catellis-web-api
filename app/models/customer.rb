class Customer < ApplicationRecord
  acts_as_paranoid

  belongs_to :restaurant, optional: false
  has_many :reservations
end
