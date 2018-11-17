class Network < ApplicationRecord
  has_many :interfaces
  serialize :configuration
end
