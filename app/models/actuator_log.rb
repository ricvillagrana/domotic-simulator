class ActuatorLog < ApplicationRecord
  belongs_to :actuator
  serialize :value
end
