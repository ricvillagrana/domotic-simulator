class CreateDevicesSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :devices_sensors do |t|
      t.references :device, foreign_key: true
      t.references :sensor, foreign_key: true
    end
  end
end
