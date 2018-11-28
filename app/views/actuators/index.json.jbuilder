json.actuators do
  json.array! @actuators do |actuator|
    json.id actuator.id
    json.name actuator.name
    unless actuator.environment.nil?
      json.environment do
        json.name actuator.environment.name
        json.unit_type actuator.environment.unit_type
        json.default actuator.environment.default
        json.minimum actuator.environment.minimum
        json.maximum actuator.environment.maximum
        json.tendence actuator.environment.tendence
        json.time_to_tendence actuator.environment.time_to_tendence
      end
    end
    json.environment_id actuator.environment_id
    json.created_at actuator.created_at
    json.updated_at actuator.updated_at
    if actuator.symbol_on.attached?
      json.symbol_on do
        json.id actuator.symbol_on.id
        json.record_type actuator.symbol_on.record_type
        json.record_id actuator.symbol_on.record_id
        json.blob_id actuator.symbol_on.blob_id
        json.created_at actuator.symbol_on.created_at
        json.name actuator.symbol_on.name
        json.filename actuator.symbol_on.filename
        json.url url_for(actuator.symbol_on)
      end
    end
    if actuator.symbol_off.attached?
      json.symbol_off do
        json.id actuator.symbol_off.id
        json.record_type actuator.symbol_off.record_type
        json.record_id actuator.symbol_off.record_id
        json.blob_id actuator.symbol_off.blob_id
        json.created_at actuator.symbol_off.created_at
        json.name actuator.symbol_off.name
        json.filename actuator.symbol_off.filename
        json.url url_for(actuator.symbol_off)
      end
    end
    if actuator.symbol_error.attached?
      json.symbol_error do
        json.id actuator.symbol_error.id
        json.record_type actuator.symbol_error.record_type
        json.record_id actuator.symbol_error.record_id
        json.blob_id actuator.symbol_error.blob_id
        json.created_at actuator.symbol_error.created_at
        json.name actuator.symbol_error.name
        json.filename actuator.symbol_error.filename
        json.url url_for(actuator.symbol_error)
      end
    end
  end
end
