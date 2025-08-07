require "rails_helper"

RSpec.describe Frame, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:center_x) }
    it { is_expected.to validate_presence_of(:center_y) }
    it { is_expected.to validate_presence_of(:width) }
    it { is_expected.to validate_presence_of(:height) }

    it { is_expected.to validate_numericality_of(:width).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:height).is_greater_than(0) }

    describe "#does_not_touch_or_overlap_other_frames" do
      let!(:existing_frame) do
        described_class.create!(center_x: 100, center_y: 100, width: 50, height: 30)
      end

      it "is invalid if it touches another frame on the right" do
        touching_frame = described_class.new(center_x: 150, center_y: 100, width: 50, height: 30)
        expect(touching_frame).not_to be_valid
        expect(touching_frame.errors[:base]).to include(a_string_including("Frame touches or overlaps another frame"))
      end

      it "is invalid if it overlaps another frame" do
        overlapping_frame = described_class.new(center_x: 110, center_y: 100, width: 50, height: 30)
        expect(overlapping_frame).not_to be_valid
        expect(overlapping_frame.errors[:base]).to include(a_string_including("Frame touches or overlaps another frame"))
      end

      it "is valid if it is clearly separated from another frame" do
        valid_frame = described_class.new(center_x: 200, center_y: 100, width: 50, height: 30)
        expect(valid_frame).to be_valid
      end
    end
  end

  describe "#highest_circle" do
    it "returns the circle with the greatest top y-position (center_y + radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_y: 90, diameter: 20, center_x: 50) # top = 100
      Circle.create!(frame: frame, center_y: 70, diameter: 10, center_x: 50) # top = 75

      expect(frame.highest_circle).to eq(c1)
    end
  end

  describe "#lowest_circle" do
    it "returns the circle with the smallest bottom y-position (center_y - radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_y: 30, diameter: 10, center_x: 60)  # bottom = 25
      Circle.create!(frame: frame, center_y: 50, diameter: 20, center_x: 50)  # bottom = 40

      expect(frame.lowest_circle).to eq(c1)
    end
  end

  describe "#leftmost_circle" do
    it "returns the circle with the smallest left x-position (center_x - radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_x: 25, center_y: 90, diameter: 10) # left = 20
      Circle.create!(frame: frame, center_x: 50, center_y: 90, diameter: 20) # left = 40

      expect(frame.leftmost_circle).to eq(c1)
    end
  end

  describe "#rightmost_circle" do
    it "returns the circle with the greatest right x-position (center_x + radius)" do
      frame = Frame.create!(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_x: 70, center_y: 80, diameter: 30) # right = 70 + 15 = 85
      Circle.create!(frame: frame, center_x: 50, center_y: 90, diameter: 10) # right = 50 + 5 = 55

      expect(frame.rightmost_circle).to eq(c1)
    end
  end

  describe "edge cases" do
    it "returns nil for all methods if there are no circles" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)

      expect(frame.highest_circle).to be_nil
      expect(frame.lowest_circle).to be_nil
      expect(frame.leftmost_circle).to be_nil
      expect(frame.rightmost_circle).to be_nil
    end
  end
end
