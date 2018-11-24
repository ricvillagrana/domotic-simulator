class Interface < ApplicationRecord
  belongs_to :network
  has_and_belongs_to_many :devices
  
  has_one_attached :symbol_off
  has_one_attached :symbol_on
  has_one_attached :symbol_error
end
