module Circle::NonOverlappingPlacement
  extend ActiveSupport::Concern

  included do
    validate :does_not_touch_other_circles
  end

  private

  def does_not_touch_other_circles
    return unless frame

    frame.circles.where.not(id: id).each do |other|
      distance = Math.sqrt((center_x - other.center_x)**2 + (center_y - other.center_y)**2)
      if distance <= (radius + other.radius)
        errors.add(:base, "Circle touches or overlaps another circle")
        break
      end
    end
  end
end
