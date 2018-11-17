class UnitType < ApplicationRecord
  has_many :sensors
  has_many :actuators
end
