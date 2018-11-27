class CreateEnvironmentRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :environment_rooms do |t|
      t.references :environment, foreign_key: true
      t.references :room, foreign_key: true
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
