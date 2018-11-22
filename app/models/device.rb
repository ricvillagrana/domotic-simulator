class Device < ApplicationRecord
  belongs_to :device_type
  has_many :log, class_name: 'DeviceLog', foreign_key: 'device_id'

  has_and_belongs_to_many :interfaces
  has_and_belongs_to_many :actuators
  has_and_belongs_to_many :sensors

  has_one_attached :image

  def type
    device_type
  end

  def changes(status, details = nil)
    log.append(DeviceLog.new(moment: DateTime.now, stauts: status, details: details))
  end

  def status
    log.last
  end
end
