class DeviceRoom < ApplicationRecord
  belongs_to :device
  belongs_to :room
end
