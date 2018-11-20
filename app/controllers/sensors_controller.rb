class SensorsController < ApplicationController
  def index
    @sensors = Sensor.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { sensors: @sensors, status: 200 }, include: ['unit_type'] }
    end
  end

  def create
    @sensor = Sensor.new(sensor_params)
    if @sensor.save
      render json: { sensor: @sensor, status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  def update
    @sensor = Sensor.find(params[:id])
    if @sensor.update!(sensor_params)
      render json: { sensor: @sensor, status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  def destroy
    @sensor = Sensor.find(params[:id])
    if @sensor.destroy
      render json: { status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  private

  def sensor_params
    params.require(:sensor).permit(:name, :unit_type_id)
  end
end
