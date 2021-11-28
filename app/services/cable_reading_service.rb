class CableReadingService < ApplicationForm

  # These are few steps to insert data into all the tables (device_readings, cable_readings and sensor_readings)
  # Message format to save
  # {
  #   "deviceId": 32, ==> Level one Device Readings
  #   "batteryLevel": 11,
  #   "data": [
  #     {
  #       "cableId":1, ==> Level two Cable Readings
  #       "timestamp": "2021-11-24T15-51-33Z",
  #       "temperatureReading": [16.29,27.20,20.27,27.49,12.91,17.31,85.85,29.39,19.80,98.81], => Level three Sensor Readings
  #       "humidityReadings": [29.14,25.17,26.97,26.83,13.46,97.87,11.03,27.69,18.68,28.08]
  #     },
  #     {
  #       "cableId":2,
  #       "timestamp": "2021-11-25T15-51-33Z",
  #       "temperatureReading": [32.27,31.99,29.12,19.20,31.55,98.59,22.75,23.95,26.55,11.04],
  #       "humidityReadings": [31.2,26.72,15.70,13.31,31.60,20.90,17.90,13.97,25.68,30.39]
  #     }
  #   ],
  #   "publishedAt": "2021-11-25T15-51-33Z"
  # }
  def feed_record_to_database
    # Step 1: Insert the Device reading
    save_device_reading
  end

  private

  def save_device_reading
    DeviceReading.create(deviceId: params.dig(:deviceId), batteryLevel: params.dig(:batteryLevel))
    # Step 2: After successful insertion of Device record,
    # Insert the value into cable_readings table
    save_cable_readings
  end

  def save_cable_readings
    # reason to convert to .to_enum and then to json is;
    # direct params are not accepted by sidekiq jobs, it has to be converted to hash.
    cable_data = params.dig(:data).to_enum.to_json
    device_id = params.dig(:deviceId)
    published_at = params.dig(:publishedAt)

    # Step 3: To insert data into cable_readings and sensor_readings table,
    # Which requires two level of loop; putting it in background job can
    # improve response time
    if Rails.env.test?
      SensorReadingJob.perform_now(cable_data, device_id, published_at)
    else
      SensorReadingJob.perform_later(cable_data, device_id, published_at)
    end
  end
end