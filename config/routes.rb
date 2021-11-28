# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'cable_readings/events', to: 'cable_readings_events#events'
  get 'cable_readings/healthcheck', to: 'cable_readings_events#healthcheck'
  get 'sensor_metrics/:device_id/peak_temp', to: 'sensor_metrics#peak_temp'
  get 'sensor_metrics/:device_id/peak_humid', to: 'sensor_metrics#peak_humid'
end
