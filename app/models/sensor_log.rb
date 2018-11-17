class SensorLog < ApplicationRecord
  belongs_to :sensor
  serialize :value
end
