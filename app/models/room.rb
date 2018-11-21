class Room < ApplicationRecord
  belongs_to :floor

  serialize :sizes
  serialize :position
  serialize :color

  has_one_attached :background
end
