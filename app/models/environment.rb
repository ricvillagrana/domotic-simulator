class Environment < ApplicationRecord
  belongs_to :unit_type
  has_many :environment_rooms
  has_many :sensors
  has_many :actuators
  has_many :rooms, through: :environment_rooms
end
