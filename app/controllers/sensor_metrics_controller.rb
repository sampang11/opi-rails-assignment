class SensorMetricsController < ApplicationController

  # method gets the peak temp on given range of dates.
  # passing sensor type temperature, will filter temperature
  # sensors reading only.
  def peak_temp
    max_temp_result = filter_peak_reading('temperature')

    return no_data_found if max_temp_result.nil?

    json_response(
      {
        maxTemperature: max_temp_result.readingValue,
        cableId: max_temp_result.cableId
      }
    )
  end

  # method gets the peak temp on given range of dates.
  def peak_humid
    max_humid_result = filter_peak_reading('humidity')

    return no_data_found if max_humid_result.nil?

    json_response(
      {
        maxHumidity: max_humid_result.readingValue,
        cableId: max_humid_result.cableId
      }
    )
  end

  private

  def no_data_found
    json_response({ message: "Record not found" })
  end

  def filter_peak_reading(sensor_type)
    # Separating class for performing filter and query related tasks
    # Needs 2 parameters params and sensor_type; doing so we can achieve
    # both max temperature and humidity reading by same method.
    # Code Reducibility and DRY concept.
    filtered_result = SensorMetricsQuery.new(params, sensor_type)
    filtered_result.peak_reading
  end
end