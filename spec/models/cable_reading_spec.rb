require 'rails_helper'

RSpec.describe CableReading, type: :model do

  describe 'validations' do
    it { should validate_presence_of :cableId }
  end

end
