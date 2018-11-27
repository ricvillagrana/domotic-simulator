class AddEnvironmentIdToSensors < ActiveRecord::Migration[5.2]
  def change
    add_reference :sensors, :environment, foreign_key: true
  end
end
