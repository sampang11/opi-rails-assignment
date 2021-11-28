class CreateSensorReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :sensor_readings do |t|
      t.integer :sensorType
      t.decimal :readingValue
      t.integer :cableId
      t.integer :deviceId
      t.datetime :publishedAt

      t.timestamps
    end
  end
end
