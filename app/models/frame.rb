class Frame < ApplicationRecord
  include NonOverlappingPlacement, CirclePositioning

  has_many :circles, dependent: :destroy

  validates :center_x, :center_y, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than: 0 }

  accepts_nested_attributes_for :circles

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
end
