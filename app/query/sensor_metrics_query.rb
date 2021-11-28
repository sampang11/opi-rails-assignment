class SensorMetricsQuery
  attr_accessor :params, :sensor_type

  def initialize(params, sensor_type)
    @params = params
    @sensor_type = sensor_type
  end

  def peak_reading
    device_id = params.dig(:device_id)
    start_time = params.dig(:start_time)
    end_time = params.dig(:end_time)

    # Querying SensorReading model/ sensor_readings table based on deviceId, dates and sensor_type
    # based on sensor_type 'temperature' or 'humidity'; result would be fetched in that manner.
    max_value = SensorReading.where(
      deviceId: device_id,
      sensorType: sensor_type,
      publishedAt: start_time..end_time
    ).order('readingValue DESC').first

    max_value
  end
end