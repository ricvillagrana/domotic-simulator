class Network < ApplicationRecord
  has_many :interfaces
  serialize :configuration

  has_one_attached :symbol_off
  has_one_attached :symbol_on
  has_one_attached :symbol_error
end
