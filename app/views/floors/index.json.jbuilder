json.floors do
  json.array! @floors do |floor|
    json.id floor.id
    json.name floor.name
    json.position floor.position
    json.created_at floor.created_at
    json.updated_at floor.updated_at
    if floor.background.attached?
      json.background do
        json.id floor.background.id
        json.record_type floor.background.record_type
        json.record_id floor.background.record_id
        json.blob_id floor.background.blob_id
        json.created_at floor.background.created_at
        json.name floor.background.name
        json.filename floor.background.filename
        json.url url_for(floor.background)
      end
    end
  end
end
