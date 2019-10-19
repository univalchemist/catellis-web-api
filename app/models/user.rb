class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # Original Devise configuration:
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # Trimmed, JWT-only configuration
  devise :database_authenticatable, :registerable

  acts_as_paranoid

  @@restaurant_roles = [
    :restaurant_owner,
    :restaurant_employee,
  ]

  def first_associated_restaurant
    Restaurant.with_roles(@@restaurant_roles, self).first
  end
end
