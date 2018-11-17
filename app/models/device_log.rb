class DeviceLog < ApplicationRecord
  belongs_to :device
  serialize :details
end
