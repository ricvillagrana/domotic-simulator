class DeviceRoom < ApplicationRecord
  belongs_to :device
  belongs_to :room
  has_many :logs, class_name: 'DeviceRoomLog', foreign_key: 'device_room_id'

  def register_log(data)
    logs.append(data: data)
  end

  def status
    logs.last
  end

end
