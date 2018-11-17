class CreateSensorLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :sensor_logs do |t|
      t.references :sensor
      t.datetime :moment
      t.text :value

      t.timestamps
    end
  end
end
