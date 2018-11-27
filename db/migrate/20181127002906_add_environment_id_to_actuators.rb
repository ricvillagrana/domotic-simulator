class AddEnvironmentIdToActuators < ActiveRecord::Migration[5.2]
  def change
    add_reference :actuators, :environment, foreign_key: true
  end
end
