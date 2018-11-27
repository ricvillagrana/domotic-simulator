class Actuator < ApplicationRecord
  has_many :log, class_name: 'ActuatorLog', foreign_key: 'actuator_id'
  has_and_belongs_to_many :devices
  belongs_to :environment

  has_one_attached :symbol_off
  has_one_attached :symbol_on
  has_one_attached :symbol_error

  def acts(data)
    log.append(ActuatorLog.new(moment: DateTime.now, value: data))
  end

  def status
    log.last
  end
end
