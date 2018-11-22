class DeviceTypesController < ApplicationController
  def index
    @device_types = DeviceType.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { device_types: @device_types } }
    end
  end

  def show
    @floor = Floor.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { device_types: @floor.device_types, status: 200 } }
    end
  end

  def create
    @device_type = DeviceType.new(device_type_params)
    @device_type.image = ActiveStorage::Blob.find params[:image][:id] if params[:image]
    if @device_type.save
      render json: { device_types: @device_type, status: 200 }
    else
      render json: { errors: @device_type.errors, status: 500 }
    end
  end

  def update
    @device_type = DeviceType.find(params[:id])
    if params[:image]
      @device_type.image.purge
      @device_type.image = ActiveStorage::Blob.find params[:image][:id]
      @device_type.save
    end
    if @device_type.update!(device_type_params)
      render json: { device_type: @device_type, status: 200 }
    else
      render json: { errors: @device_type.errors, status: 500 }
    end
  end

  def destroy
    @device_type = DeviceType.find(params[:id])
    @device_type.image.purge
    if @device_type.destroy
      render json: { status: 200 }
    else
      render json: { errors: @DeviceType.errors, status: 500 }
    end
  end

  private

  def device_type_params
    params.require(:device_type).permit(:name, :description)
  end
end
