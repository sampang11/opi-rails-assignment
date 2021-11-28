class SensorReadingJob < ApplicationJob
  queue_as :sensor_jobs

  attr_accessor :device_id, :published_at

  def perform(cable_readings, device_id, published_at)
    # converted json has to be parsed,
    # otherwise it cannot be treated as an object
    cable_data = JSON.parse(cable_readings)
    @device_id = device_id
    @published_at = published_at
    # loop through every data and save it individually in cable_readings table
    cable_data.each do |cable_datum|
      save_cable_reading(cable_datum)
    end
  end

  private

  def save_cable_reading(cable_datum)
    # loop twice for saving;
    # 1. temperatureReading
    # 2. humidityReading
    %w[temperature humidity].each do |sensor|
      sensor_reading = (sensor == 'temperature') ? 'temperatureReading' : 'humidityReadings'

      save_sensor_reading(
        sensor,
        cable_datum.dig(sensor_reading),
        cable_datum.dig('cableId')
      )
    end
  end

  def save_sensor_reading(sensor_type, reading_values, cable_id)
    # Looping through sensors readings from every cable datum and
    # saving it individually
    reading_values.each do |reading|
      SensorReading.create(
        sensorType: sensor_type,
        readingValue: reading,
        cableId: cable_id,
        deviceId: device_id,
        publishedAt: published_at
      )
    end
  end

end
