require "rails_helper"

RSpec.describe Circle, type: :model do
  let!(:frame) { Frame.create!(center_x: 100.0, center_y: 100.0, width: 50.0, height: 30.0) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:center_x) }
    it { is_expected.to validate_presence_of(:center_y) }
    it { is_expected.to validate_presence_of(:diameter) }
  end
end
