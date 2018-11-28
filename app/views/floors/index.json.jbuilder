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
    json.rooms do
      json.array! floor.rooms do |room|
        json.id room.id
        json.floor_id room.floor_id
        json.name room.name
        json.environments room.environments
        json.sizes room.sizes.as_json
        json.position room.position.as_json
        json.color room.color.as_json
        json.created_at room.created_at
        json.updated_at room.updated_at
      end
    end
  end
end
