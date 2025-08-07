require "rails_helper"

RSpec.describe Frame::NonOverlappingPlacement do
  describe "#does_not_touch_or_overlap_other_frames" do
    let!(:existing_frame) do
      Frame.create!(center_x: 100, center_y: 100, width: 50, height: 30)
    end

    it "is invalid if it touches another frame on the right" do
      touching_frame = Frame.new(center_x: 150, center_y: 100, width: 50, height: 30)
      expect(touching_frame).not_to be_valid
      expect(touching_frame.errors[:base]).to include(a_string_including("Frame touches or overlaps another frame"))
    end

    it "is invalid if it overlaps another frame" do
      overlapping_frame = Frame.new(center_x: 110, center_y: 100, width: 50, height: 30)
      expect(overlapping_frame).not_to be_valid
      expect(overlapping_frame.errors[:base]).to include(a_string_including("Frame touches or overlaps another frame"))
    end

    it "is valid if it is clearly separated from another frame" do
      valid_frame = Frame.new(center_x: 200, center_y: 100, width: 50, height: 30)
      expect(valid_frame).to be_valid
    end
  end
end
