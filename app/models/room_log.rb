class RoomLog < ApplicationRecord
  belongs_to :room
  
  serialize :data
end
