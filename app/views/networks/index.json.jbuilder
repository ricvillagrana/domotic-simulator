json.networks do
  json.array! @networks do |network|
    json.id network.id
    json.name network.name
    json.description network.description
    json.configuration network.configuration
    json.created_at network.created_at
    json.updated_at network.updated_at
    if network.symbol.attached?
      json.symbol do
        json.id network.symbol.id
        json.record_type network.symbol.record_type
        json.record_id network.symbol.record_id
        json.blob_id network.symbol.blob_id
        json.created_at network.symbol.created_at
        json.name network.symbol.name
        json.filename network.symbol.filename
        json.url url_for(network.symbol)
      end
    end
  end
end
