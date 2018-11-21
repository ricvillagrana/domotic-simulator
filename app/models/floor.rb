class Floor < ApplicationRecord
  has_many :rooms
  has_one_attached :background
end
