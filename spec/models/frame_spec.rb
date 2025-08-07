require "rails_helper"

RSpec.describe Frame, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:center_x) }
    it { is_expected.to validate_presence_of(:center_y) }
    it { is_expected.to validate_presence_of(:width) }
    it { is_expected.to validate_presence_of(:height) }

    it { is_expected.to validate_numericality_of(:width).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:height).is_greater_than(0) }
  end
end
