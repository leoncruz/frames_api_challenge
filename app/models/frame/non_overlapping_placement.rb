module Frame::NonOverlappingPlacement
  extend ActiveSupport::Concern

  included do
    validate :does_not_touch_or_overlap_other_frames
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
