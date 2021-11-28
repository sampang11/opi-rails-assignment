class CreateCableReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :cable_readings do |t|
      t.integer :cableId
      t.integer :deviceId

      t.timestamps
    end
  end
end
