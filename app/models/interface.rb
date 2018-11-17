class Interface < ApplicationRecord
  belongs_to :network
  has_and_belongs_to_many :devices
end
