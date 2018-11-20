json.networks do
  json.array! @networks do |network|
    json.id network.id
    json.name network.name
    json.description network.description
    json.configuration network.configuration
    json.created_at network.created_at
    json.updated_at network.updated_at
    if network.symbol_on.attached?
      json.symbol_on do
        json.id network.symbol_on.id
        json.record_type network.symbol_on.record_type
        json.record_id network.symbol_on.record_id
        json.blob_id network.symbol_on.blob_id
        json.created_at network.symbol_on.created_at
        json.name network.symbol_on.name
        json.filename network.symbol_on.filename
        json.url url_for(network.symbol_on)
      end
    end
    if network.symbol_off.attached?
      json.symbol_off do
        json.id network.symbol_off.id
        json.record_type network.symbol_off.record_type
        json.record_id network.symbol_off.record_id
        json.blob_id network.symbol_off.blob_id
        json.created_at network.symbol_off.created_at
        json.name network.symbol_off.name
        json.filename network.symbol_off.filename
        json.url url_for(network.symbol_off)
      end
    end
    if network.symbol_error.attached?
      json.symbol_error do
        json.id network.symbol_error.id
        json.record_type network.symbol_error.record_type
        json.record_id network.symbol_error.record_id
        json.blob_id network.symbol_error.blob_id
        json.created_at network.symbol_error.created_at
        json.name network.symbol_error.name
        json.filename network.symbol_error.filename
        json.url url_for(network.symbol_error)
      end
    end
  end
end
