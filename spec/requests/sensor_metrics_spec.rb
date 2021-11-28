# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Sensor metrics", :type => :request do

  let!(:data) {
    {
      deviceId: 32,
      batteryLevel: 11,
      data: [
        {
          cableId: 1,
          timestamp: '2021-11-24T15-51-33Z',
          temperatureReading: [16.29,27.20,20.27,27.49,12.91,17.31,85.85,29.39,19.80,98.81],
          humidityReadings: [29.14,25.17,26.97,26.83,13.46,97.87,11.03,27.69,18.68,28.08]
        },
        {
          cableId:2,
          timestamp: '2021-11-25T15-51-33Z',
          temperatureReading: [32.27,31.99,29.12,19.20,31.55,98.59,22.75,23.95,26.55,11.04],
          humidityReadings: [31.2,26.72,15.70,13.31,31.60,20.90,17.90,13.97,25.68,30.39]
        }
      ],
      'publishedAt': '2021-11-27 01:00:00 UTC'
    }
  }

  let!(:cable_events) { post cable_readings_events_path, { params: data } }

  context 'When published date is within range' do
    it 'should return max temperature from data collected in one hour' do
      device_id = 32
      start_time = '2021-11-27 01:00:00 UTC'
      end_time = '2021-11-27 02:00:00 UTC'

      get "/sensor_metrics/#{device_id}/peak_temp?start_time=#{start_time}&end_time=#{end_time}"
      expect(JSON.parse(response.body).dig('maxTemperature')).to eq('98.81')
    end

    it 'should return max humidity from data collected in one hour' do
      device_id = 32
      start_time = '2021-11-27 01:00:00 UTC'
      end_time = '2021-11-27 02:00:00 UTC'

      get "/sensor_metrics/#{device_id}/peak_humid?start_time=#{start_time}&end_time=#{end_time}"
      expect(JSON.parse(response.body).dig('maxHumidity')).to eq('97.87')
    end
  end

  context 'When published date is out of range from the record present in database' do
    it 'should not return a value; should return `Record not found` message' do
      device_id = 32
      start_time = '2021-11-27 02:00:00 UTC'
      end_time = '2021-11-27 03:00:00 UTC'

      get "/sensor_metrics/#{device_id}/peak_temp?start_time=#{start_time}&end_time=#{end_time}"
      expect(JSON.parse(response.body).dig('message')).to eq('Record not found')
    end
  end
end
