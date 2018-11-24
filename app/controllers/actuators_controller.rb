class ActuatorsController < ApplicationController
  def index
    @actuators = Actuator.all.order(id: :desc)
  end

  def create
    @actuator = Actuator.new(actuator_params)
    set_symbols(@actuator, params[:blobs])
    if @actuator.save
      render json: { actuator: @actuator, status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  def update
    @actuator = Actuator.find(params[:id])
    set_symbols(@actuator, params[:blobs])
    if @actuator.update!(actuator_params)
      render json: { actuator: @actuator, status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  def destroy
    @actuator = Actuator.find(params[:id])
    purge_symbols(@actuator)
    if @actuator.destroy
      render json: { status: 200 }
    else
      render json: { errors: @actuator.errors, status: 500 }
    end
  end

  def set_symbols(actuator, blobs)
    actuator.symbol_off = ActiveStorage::Blob.find blobs[:symbol_off][:id] if blobs[:symbol_off]
    actuator.symbol_on = ActiveStorage::Blob.find blobs[:symbol_on][:id] if blobs[:symbol_on]
    actuator.symbol_error = ActiveStorage::Blob.find blobs[:symbol_error][:id] if blobs[:symbol_error]
    actuator.save
  end

  def purge_symbols(actuator)
    actuator.symbol_off.purge
    actuator.symbol_on.purge
    actuator.symbol_error.purge
  end

  private

  def actuator_params
    params.require(:actuator).permit(:name, :unit_type_id)
  end
end
