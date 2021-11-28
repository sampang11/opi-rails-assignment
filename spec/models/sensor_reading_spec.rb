require 'rails_helper'

RSpec.describe SensorReading, type: :model do

  describe 'validations' do
    it { should validate_presence_of :cableId }
    it { should validate_presence_of :deviceId }
    it { should validate_presence_of :sensorType }
    it { should validate_presence_of :readingValue }
    it { should validate_presence_of :publishedAt }
  end

end
