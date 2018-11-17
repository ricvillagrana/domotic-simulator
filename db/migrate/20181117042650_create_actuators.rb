class CreateActuators < ActiveRecord::Migration[5.2]
  def change
    create_table :actuators do |t|
      t.string :name
      t.string :serial
      t.references :unit_type

      t.timestamps
    end
  end
end
