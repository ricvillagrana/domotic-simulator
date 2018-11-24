json.id interface.id
json.name interface.name
json.created_at interface.created_at
json.updated_at interface.updated_at
if interface.symbol_on.attached?
  json.symbol_on do
    json.id interface.symbol_on.id
    json.record_type interface.symbol_on.record_type
    json.record_id interface.symbol_on.record_id
    json.blob_id interface.symbol_on.blob_id
    json.created_at interface.symbol_on.created_at
    json.name interface.symbol_on.name
    json.filename interface.symbol_on.filename
    json.url url_for(interface.symbol_on)
  end
end
if interface.symbol_off.attached?
  json.symbol_off do
    json.id interface.symbol_off.id
    json.record_type interface.symbol_off.record_type
    json.record_id interface.symbol_off.record_id
    json.blob_id interface.symbol_off.blob_id
    json.created_at interface.symbol_off.created_at
    json.name interface.symbol_off.name
    json.filename interface.symbol_off.filename
    json.url url_for(interface.symbol_off)
  end
end
if interface.symbol_error.attached?
  json.symbol_error do
    json.id interface.symbol_error.id
    json.record_type interface.symbol_error.record_type
    json.record_id interface.symbol_error.record_id
    json.blob_id interface.symbol_error.blob_id
    json.created_at interface.symbol_error.created_at
    json.name interface.symbol_error.name
    json.filename interface.symbol_error.filename
    json.url url_for(interface.symbol_error)
  end
end
