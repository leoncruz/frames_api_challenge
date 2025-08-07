class FramesController < ApplicationController
  before_action :set_frame, only: [ :show, :destroy ]

  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      render json: { frame: @frame }, status: :created
    else
      render json: { errors: @frame.errors.full_messages }, status: :unprocessable_content
    end
  end

  def show
    render json: {
      position: {
        x: @frame.center_x,
        y: @frame.center_y
      },
      circles_count: @frame.circles.count,
      highest_circle: { x: @frame.highest_circle.center_x, y: @frame.highest_circle.center_y },
      lowest_circle: { x: @frame.lowest_circle.center_x, y: @frame.lowest_circle.center_y },
      leftmost_circle: { x: @frame.leftmost_circle.center_x, y: @frame.leftmost_circle.center_y },
      rightmost_circle: { x: @frame.leftmost_circle.center_x, y: @frame.leftmost_circle.center_y }
    }
  end

  def destroy
    if @frame.circles.empty? && @frame.destroy
      head :no_content
    else
      render json: { errors: "Frame could not be deleted" }, status: :unprocessable_content
    end
  end

  private

  def set_frame
    @frame = Frame.find(params[:id])
  end

  def frame_params
    params.require(:frame).permit(:center_x, :center_y, :width, :height)
  end
end
