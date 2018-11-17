class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :serial
      t.text :description
      t.references :device_type, foreign_key: true

      t.timestamps
    end
  end
end
