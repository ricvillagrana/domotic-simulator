json.devices do
  json.array! @devices do |device|
    json.id device.id
    json.name device.name
    json.description device.description
    json.default device.default
    json.miinimum device.miinimum
    json.maximum device.maximum
    json.tendence device.tendence
    json.time_to_tendence device.time_to_tendence
    json.device_type device.device_type
    json.device_type_id device.device_type_id
    json.created_at device.created_at
    json.updated_at device.updated_at

    json.sensors do
      json.array! device.sensors do |sensor|
        json.partial! 'sensor', sensor: sensor
      end
    end

    json.actuators do
      json.array! device.actuators do |actuator|
        json.partial! 'actuator', actuator: actuator
      end
    end

    json.interfaces do
      json.array! device.interfaces do |interface|
        json.partial! 'interface', interface: interface
      end
    end

    if device.image.attached?
      json.image do
        json.id device.image.id
        json.record_type device.image.record_type
        json.record_id device.image.record_id
        json.blob_id device.image.blob_id
        json.created_at device.image.created_at
        json.name device.image.name
        json.filename device.image.filename
        json.url url_for(device.image)
      end
    end
  end
end
