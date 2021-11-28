require 'rails_helper'

RSpec.describe DeviceReading, type: :model do

  describe 'validations' do
    it { should validate_presence_of :deviceId }
    it { should validate_presence_of :batteryLevel }
  end

end
