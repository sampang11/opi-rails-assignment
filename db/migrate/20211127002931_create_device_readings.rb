class CreateDeviceReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :device_readings do |t|
      t.integer :deviceId
      t.integer :batteryLevel

      t.timestamps
    end
  end
end
