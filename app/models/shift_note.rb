class ShiftNote < ApplicationRecord
  acts_as_paranoid

  belongs_to :restaurant
  belongs_to :author, class_name: 'User'
end
