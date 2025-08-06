class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :diameter, :frame, presence: true
  validates :diameter, numericality: { greater_than: 0 }

  validate :does_not_touch_other_circles
  validate :fits_inside_frame

  def radius
    diameter / 2
  end

  def left
    center_x - radius
  end

  def right
    center_x + radius
  end

  def top
    center_y + radius
  end

  def bottom
    center_y - radius
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

  def fits_inside_frame
    return unless frame

    if left < frame.left || right > frame.right || bottom < frame.bottom || top > frame.top
      errors.add(:base, "Circle does not fit inside the frame")
    end
  end
end
