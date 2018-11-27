class Room < ApplicationRecord
  belongs_to :floor
  has_many :environment_rooms
  has_many :environments, through: :environment_rooms

  def env
    environments
  end

  serialize :sizes
  serialize :position
  serialize :color

  has_one_attached :background
end
