class CreateActuatorLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :actuator_logs do |t|
      t.references :actuator
      t.datetime :moment
      t.text :value

      t.timestamps
    end
  end
end
