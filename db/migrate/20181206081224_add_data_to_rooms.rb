class AddDataToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :data, :text
  end
end
