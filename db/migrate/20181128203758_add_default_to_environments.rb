class AddDefaultToEnvironments < ActiveRecord::Migration[5.2]
  def change
    add_column :environments, :default, :float
    add_column :environments, :minimum, :float
    add_column :environments, :maximum, :float
    add_column :environments, :tendence, :float
    add_column :environments, :time_to_tendence, :integer
  end
end
