class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :floor, foreign_key: true
      t.string :name
      t.text :sizes
      t.text :position
      t.text :color

      t.timestamps
    end
  end
end
