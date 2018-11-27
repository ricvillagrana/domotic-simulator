class CreateEnvironments < ActiveRecord::Migration[5.2]
  def change
    create_table :environments do |t|
      t.string :name
      t.references :unit_type, foreign_key: true

      t.timestamps
    end
  end
end
