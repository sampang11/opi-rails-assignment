# frozen_string_literal: true

class CableReadingsEventsController < ApplicationController

  def events
    puts params.to_json
    # Separating logic in different service class;
    # which would perform data insertion on different tables
    cable_reading = CableReadingService.new(params)
    cable_reading.feed_record_to_database

    json_response({ status: 'received' }, :created)
  end

  def healthcheck
    json_response({ status: 'ok' })
  end
end
