class DeviceRoomLog < ApplicationRecord
  belongs_to :device_room

  serialize :data
end
