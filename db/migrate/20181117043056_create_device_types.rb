class CreateDeviceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :device_types do |t|
      t.string :name
      t.text :description
      t.text :specifications

      t.timestamps
    end
  end
end
