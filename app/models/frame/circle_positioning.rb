module Frame::CirclePositioning
  extend ActiveSupport::Concern

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
