class Circle < ApplicationRecord
  include NonOverlappingPlacement

  belongs_to :frame

  validates :center_x, :center_y, :diameter, :frame, presence: true
  validates :diameter, numericality: { greater_than: 0 }

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

  def fits_inside_frame
    return unless frame

    if left < frame.left || right > frame.right || bottom < frame.bottom || top > frame.top
      errors.add(:base, "Circle does not fit inside the frame")
    end
  end
end
