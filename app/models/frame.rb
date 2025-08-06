class Frame < ApplicationRecord
  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }
  validate :does_not_touch_or_overlap_other_frames

  def left
    center_x - width / 2
  end

  def right
    center_x + width / 2
  end

  def top
    center_y + height / 2
  end

  def bottom
    center_y - height / 2
  end

  private

  def does_not_touch_or_overlap_other_frames
    Frame.where.not(id: id).find_each do |other|
      if overlaps_or_touches?(other)
        errors.add(:base, "Frame touches or overlaps another frame (ID=#{other.id})")
        break
      end
    end
  end

  def overlaps_or_touches?(other)
    !(right < other.left ||
      left > other.right ||
      top < other.bottom ||
      bottom > other.top)
  end
end
