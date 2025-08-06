class FramesController < ApplicationController
  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      render json: { frame: @frame }, status: :created
    else
      render json: { errors: @frame.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def frame_params
    params.require(:frame).permit(:center_x, :center_y, :width, :height)
  end
end
