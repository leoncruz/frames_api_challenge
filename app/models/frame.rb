class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy

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

  def highest_circle
    circle_on_extreme(:top)
  end

  def lowest_circle
    circle_on_extreme(:bottom)
  end

  def leftmost_circle
    circle_on_extreme(:left)
  end

  def rightmost_circle
    circle_on_extreme(:right)
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

  def circle_on_extreme(direction)
    return nil if circles.empty?

    case direction
    when :top
      circles.max_by { |c| c.center_y + c.radius }
    when :bottom
      circles.min_by { |c| c.center_y - c.radius }
    when :left
      circles.min_by { |c| c.center_x - c.radius }
    when :right
      circles.max_by { |c| c.center_x + c.radius }
    end
  end
end
