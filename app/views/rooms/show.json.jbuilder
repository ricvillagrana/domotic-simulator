json.room do
  json.id @room.id
  json.floor_id @room.floor_id
  json.name @room.name
  json.data @room.data.as_json
  json.environments @room.environments
  json.data @room.data.as_json
  json.sizes @room.sizes.as_json
  json.position @room.position.as_json
  json.color @room.color.as_json
  json.created_at @room.created_at
  json.updated_at @room.updated_at
  json.devices do
    json.array! @room.device_rooms do |device_room|
      json.id device_room.device.id
      json.name device_room.device.name
      json.device_type device_room.device.device_type
      json.device_type_id device_room.device.device_type_id
      json.description device_room.device.description
      json.sensors do
        json.array! device_room.device.sensors do |sensor|
          json.id sensor.id
          json.name sensor.name
          json.serial sensor.serial
          json.unit_type_id sensor.unit_type_id
          json.environment_id sensor.environment_id
          json.environment sensor.environment
          json.created_at sensor.created_at
          json.updated_at sensor.updated_at
        end
      end
      json.actuators do
        json.array! device_room.device.actuators do |actuator|
          json.id actuator.id
          json.name actuator.name
          json.serial actuator.serial
          json.unit_type_id actuator.unit_type_id
          json.environment_id actuator.environment_id
          json.environment actuator.environment
          json.created_at actuator.created_at
          json.updated_at actuator.updated_at
        end
      end
      json.interfaces do
        json.array! device_room.device.interfaces do |interface|
          json.id interface.id
          json.name interface.name
          json.created_at interface.created_at
          json.updated_at interface.updated_at
        end
      end

      json.status device_room.satatus unless device_room.logs.empty?
    end
  end
end
