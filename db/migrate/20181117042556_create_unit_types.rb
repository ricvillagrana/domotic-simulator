class CreateUnitTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :unit_types do |t|
      t.string :name
      t.string :description
      t.string :unit
      t.string :symbol

      t.timestamps
    end
  end
end
