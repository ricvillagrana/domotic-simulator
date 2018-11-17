class DeviceType < ApplicationRecord
  has_many :devices
  serialize :specifications
end
