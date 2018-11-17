class CreateFloors < ActiveRecord::Migration[5.2]
  def change
    create_table :floors do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
