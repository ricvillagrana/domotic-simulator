class CreateNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :networks do |t|
      t.string :name
      t.string :description
      t.text :configuration

      t.timestamps
    end
  end
end
