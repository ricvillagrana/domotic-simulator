json.id sensor.id
json.name sensor.name
unless sensor.environment.nil?
  json.environment do
    json.name sensor.environment.name
    json.unit_type sensor.environment.unit_type
  end
end
json.environment_id sensor.environment_id
json.created_at sensor.created_at
json.updated_at sensor.updated_at
if sensor.symbol_on.attached?
  json.symbol_on do
    json.id sensor.symbol_on.id
    json.record_type sensor.symbol_on.record_type
    json.record_id sensor.symbol_on.record_id
    json.blob_id sensor.symbol_on.blob_id
    json.created_at sensor.symbol_on.created_at
    json.name sensor.symbol_on.name
    json.filename sensor.symbol_on.filename
    json.url url_for(sensor.symbol_on)
  end
end
if sensor.symbol_off.attached?
  json.symbol_off do
    json.id sensor.symbol_off.id
    json.record_type sensor.symbol_off.record_type
    json.record_id sensor.symbol_off.record_id
    json.blob_id sensor.symbol_off.blob_id
    json.created_at sensor.symbol_off.created_at
    json.name sensor.symbol_off.name
    json.filename sensor.symbol_off.filename
    json.url url_for(sensor.symbol_off)
  end
end
if sensor.symbol_error.attached?
  json.symbol_error do
    json.id sensor.symbol_error.id
    json.record_type sensor.symbol_error.record_type
    json.record_id sensor.symbol_error.record_id
    json.blob_id sensor.symbol_error.blob_id
    json.created_at sensor.symbol_error.created_at
    json.name sensor.symbol_error.name
    json.filename sensor.symbol_error.filename
    json.url url_for(sensor.symbol_error)
  end
end
