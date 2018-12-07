class Room < ApplicationRecord
  belongs_to :floor
  has_many :room_logs

  has_many :environment_rooms
  has_many :environments, through: :environment_rooms

  has_many :device_rooms
  has_many :devices, through: :device_rooms

  serialize :data


  def env
    environments
  end

  def logs
    room_logs.all
  end

  def register_log(data)
    room_logs.append(RoomLog.new(data: data))
  end

  serialize :sizes
  serialize :position
  serialize :color

  has_one_attached :background
end
