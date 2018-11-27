class CreateDeviceRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :device_rooms do |t|
      t.references :device, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
