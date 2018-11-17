class CreateActuatorsDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :actuators_devices do |t|
      t.references :device, foreign_key: true
      t.references :actuator, foreign_key: true
    end
  end
end
