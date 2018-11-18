class Network < ApplicationRecord
  has_many :interfaces
  serialize :configuration

  has_one_attached :symbol
end
