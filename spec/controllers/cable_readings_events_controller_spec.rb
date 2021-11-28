# frozen_string_literal: true

require 'rails_helper'

describe CableReadingsEventsController do


  context 'with valid parameters' do
    let!(:data) {
      {
        deviceId: 32,
        batteryLevel: 11,
        data: [
          {
            cableId: 1,
            timestamp: '2021-11-24T15-51-33Z',
            temperatureReading: [16.29,27.20,20.27,27.49,12.91,17.31,85.85,29.39,19.80,99.81],
            humidityReadings: [29.14,25.17,26.97,26.83,13.46,97.87,11.03,27.69,18.68,28.08]
          },
          {
            cableId:2,
            timestamp: '2021-11-25T15-51-33Z',
            temperatureReading: [32.27,31.99,99.99,19.20,31.55,98.59,22.75,23.95,26.55,11.04],
            humidityReadings: [31.2,26.72,15.70,13.31,31.60,20.90,17.90,13.97,25.68,30.39]
          }
        ],
        'publishedAt': '2021-11-24T15-57-33Z'
      }
    }

    it 'should return received status' do
      expect {
        post :events, { params: data  }
      }.to change(DeviceReading, :count).by(1)
      expect(JSON.parse(response.body).dig('status')).to eq('received')
    end
  end
end
