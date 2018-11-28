class CreateRoomLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :room_logs do |t|
      t.references :room, foreign_key: true
      t.text :data
      t.timestamps
    end
  end
end
