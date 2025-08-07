require "rails_helper"

RSpec.describe Frame::CirclePositioning do
  describe "#highest_circle" do
    it "returns the circle with the greatest top y-position (center_y + radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_y: 90, diameter: 20, center_x: 50)
      Circle.create!(frame: frame, center_y: 70, diameter: 10, center_x: 50)

      expect(frame.highest_circle).to eq(c1)
    end
  end

  describe "#lowest_circle" do
    it "returns the circle with the smallest bottom y-position (center_y - radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_y: 30, diameter: 10, center_x: 60)
      Circle.create!(frame: frame, center_y: 50, diameter: 20, center_x: 50)

      expect(frame.lowest_circle).to eq(c1)
    end
  end

  describe "#leftmost_circle" do
    it "returns the circle with the smallest left x-position (center_x - radius)" do
      frame = Frame.create(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_x: 25, center_y: 90, diameter: 10)
      Circle.create!(frame: frame, center_x: 50, center_y: 90, diameter: 20)

      expect(frame.leftmost_circle).to eq(c1)
    end
  end

  describe "#rightmost_circle" do
    it "returns the circle with the greatest right x-position (center_x + radius)" do
      frame = Frame.create!(width: 200, height: 200, center_x: 0, center_y: 0)
      c1 = Circle.create!(frame: frame, center_x: 70, center_y: 80, diameter: 30)
      Circle.create!(frame: frame, center_x: 50, center_y: 90, diameter: 10)

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
