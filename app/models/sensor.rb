class Sensor < ApplicationRecord
  has_many :log, class_name: 'SensorLog', foreign_key: 'sensor_id'
  has_and_belongs_to_many :devices
  belongs_to :unit_type

  has_one_attached :symbol_off
  has_one_attached :symbol_on
  has_one_attached :symbol_error

  def senses(data)
    log.append(SensorLog.new(moment: DateTime.now, value: data))
  end

  def status
    log.last
  end
end
