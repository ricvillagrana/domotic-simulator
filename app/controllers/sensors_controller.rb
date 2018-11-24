class SensorsController < ApplicationController
  def index
    @sensors = Sensor.all.order(id: :desc)
  end

  def create
    @sensor = Sensor.new(sensor_params)
    set_symbols(@sensor, params[:blobs])
    if @sensor.save
      render json: { sensor: @sensor, status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  def update
    @sensor = Sensor.find(params[:id])
    set_symbols(@sensor, params[:blobs])
    if @sensor.update!(sensor_params)
      render json: { sensor: @sensor, status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  def destroy
    @sensor = Sensor.find(params[:id])
    purge_symbols(@sensor)
    if @sensor.destroy
      render json: { status: 200 }
    else
      render json: { errors: @sensor.errors, status: 500 }
    end
  end

  def set_symbols(sensor, blobs)
    sensor.symbol_off = ActiveStorage::Blob.find blobs[:symbol_off][:id] if blobs[:symbol_off]
    sensor.symbol_on = ActiveStorage::Blob.find blobs[:symbol_on][:id] if blobs[:symbol_on]
    sensor.symbol_error = ActiveStorage::Blob.find blobs[:symbol_error][:id] if blobs[:symbol_error]
    sensor.save
  end

  def purge_symbols(sensor)
    sensor.symbol_off.purge
    sensor.symbol_on.purge
    sensor.symbol_error.purge
  end

  private

  def sensor_params
    params.require(:sensor).permit(:name, :unit_type_id)
  end
end
