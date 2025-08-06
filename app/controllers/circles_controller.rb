class CirclesController < ApplicationController
  before_action :set_frame, only: :create

  def create
    @circle = @frame.circles.build(circle_params)

    if @circle.save
      render json: { circle: @circle }, status: :created
    else
      render json: { errors: @circle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @circle = Circle.find(params[:id])

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

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :diameter)
  end
end
