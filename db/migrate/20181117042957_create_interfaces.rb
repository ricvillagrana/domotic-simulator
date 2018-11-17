class CreateInterfaces < ActiveRecord::Migration[5.2]
  def change
    create_table :interfaces do |t|
      t.string :name
      t.text :description
      t.references :network, foreign_key: true

      t.timestamps
    end
  end
end
