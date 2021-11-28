class DeviceReading < ApplicationRecord
  validates_presence_of :deviceId, :batteryLevel
end
