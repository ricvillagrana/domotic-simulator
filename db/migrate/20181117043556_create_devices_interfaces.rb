class CreateDevicesInterfaces < ActiveRecord::Migration[5.2]
  def change
    create_table :devices_interfaces do |t|
      t.references :device, foreign_key: true
      t.references :interface, foreign_key: true
    end
  end
end
