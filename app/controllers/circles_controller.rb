class CirclesController < ApplicationController
  before_action :set_frame, only: :create
  before_action :set_circle, only: [ :update, :destroy ]

  def index
    center_x = params[:center_x]&.to_f
    center_y = params[:center_y]&.to_f
    radius = params[:radius]&.to_f
    frame_id = params[:frame_id]

    circles = Circle.all
    circles = circles.where(frame_id: frame_id) if frame_id.present?

    circles = circles.where(
      <<-SQL.squish, center_x: center_x, center_y: center_y, radius: radius
        (SQRT(POWER(center_x - :center_x, 2) + POWER(center_y - :center_y, 2)) + (diameter / 2.0)) <= :radius
      SQL
    )

    render json: { circles: circles }, status: :ok
  end

  def create
    @circle = @frame.circles.build(circle_params)

    if @circle.save
      render json: { circle: @circle }, status: :created
    else
      render json: { errors: @circle.errors.full_messages }, status: :unprocessable_content
    end
  rescue StandardError
    render json: { errors: @circle.errors.full_messages }, status: :unprocessable_content
  end

  def update
    if @circle.update(circle_params)
      render json: { circle: @circle }, status: :ok
    else
      render json: { errors: @circle.errors.full_messages }, status: :unprocessable_content
    end
  rescue StandardError
    render json: { errors: @circle.errors.full_messages }, status: :unprocessable_content
  end

  def destroy
    if @circle.destroy
      head :no_content
    else
      render json: { errors: "Circle could not be deleted" }, status: :not_found
    end
  end

  private

  def set_frame
    @frame = Frame.find(params[:frame_id])
  end

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
