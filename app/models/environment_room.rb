class EnvironmentRoom < ApplicationRecord
  belongs_to :environment
  belongs_to :room
end
