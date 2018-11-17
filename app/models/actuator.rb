class Actuator < ApplicationRecord
  has_many :log, class_name: 'ActuatorLog', foreign_key: 'actuator_id'
  has_and_belongs_to_many :devices
  belongs_to :unit_type

  def acts(data)
    log.append(ActuatorLog.new(moment: DateTime.now, value: data))
  end
  
  def status
    log.last
  end
end
