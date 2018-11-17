class CreateDeviceLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :device_logs do |t|
      t.references :device
      t.datetime :moment
      t.boolean :status
      t.text :details

      t.timestamps
    end
  end
end
