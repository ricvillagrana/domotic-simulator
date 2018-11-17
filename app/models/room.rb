class Room < ApplicationRecord
  belongs_to :floor

  serialize :sizes
  serialize :position
  serialize :color
end
