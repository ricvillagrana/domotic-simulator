class CreateDeviceRoomLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :device_room_logs do |t|
      t.references :device_room, foreign_key: true
      t.text :data
      t.timestamps
    end
  end
end
