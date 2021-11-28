class SensorReading < ApplicationRecord
  validates_presence_of :cableId, :deviceId, :sensorType, :readingValue, :publishedAt

  enum sensorType: { temperature: 0, humidity: 1 }
end
