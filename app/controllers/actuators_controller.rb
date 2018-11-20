class ActuatorsController < ApplicationController
  def index
    @actuators = Actuator.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { actuators: @actuators, status: 200 }, include: ['unit_type'] }
    end
  end

  def create
    @actuator = Actuator.new(actuator_params)
    if @actuator.save
      render json: { actuator: @actuator, status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  def update
    @actuator = Actuator.find(params[:id])
    if @actuator.update!(actuator_params)
      render json: { actuator: @actuator, status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  def destroy
    @actuator = Actuator.find(params[:id])
    if @actuator.destroy
      render json: { status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  private

  def actuator_params
    params.require(:actuator).permit(:name, :unit_type_id)
  end
end
