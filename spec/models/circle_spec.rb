require "rails_helper"

RSpec.describe Circle, type: :model do
  let!(:frame) { Frame.create!(center_x: 100.0, center_y: 100.0, width: 50.0, height: 30.0) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:center_x) }
    it { is_expected.to validate_presence_of(:center_y) }
    it { is_expected.to validate_presence_of(:diameter) }

    describe "#does_not_touch_other_circles" do
      subject(:circle) { described_class.new(center_x: 90.0, center_y: 100.0, diameter: 20.0, frame: frame) }

      it "is invalid if it does not fit inside the frame" do
        circle.center_x = 120.0
        circle.diameter = 20.0
        expect(circle).not_to be_valid
        expect(circle.errors[:base]).to include("Circle does not fit inside the frame")
      end

      it "is invalid if it touches or overlaps another circle in the same frame" do
        described_class.create!(
          center_x: 115.0,
          center_y: 100.0,
          diameter: 20.0,
          frame: frame
        )

        touching_circle = described_class.new(
          center_x: 95.0,
          center_y: 100.0,
          diameter: 20.0,
          frame: frame
        )

        expect(touching_circle).not_to be_valid
        expect(touching_circle.errors[:base].first).to match(/Circle touches or overlaps another circle/)
      end

      it "is valid when far enough from other circles" do
        described_class.create!(
          center_x: 115.0,
          center_y: 100.0,
          diameter: 20.0,
          frame: frame
        )

        safe_circle = described_class.new(
          center_x: 80.0,
          center_y: 100.0,
          diameter: 10.0,
          frame: frame
        )

        expect(safe_circle).to be_valid
      end
    end
  end
end
