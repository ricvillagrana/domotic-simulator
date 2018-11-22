class DevicesController < ApplicationController
  def index
    @devices = Device.all.order(id: :desc)
  end

  def show
    @floor = Floor.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { devices: @floor.devices, status: 200 } }
    end
  end

  def create
    @device = Device.new(device_params)
    @device.image = ActiveStorage::Blob.find params[:image][:id] if params[:image]
    if @device.save
      render json: { Device: @device, status: 200 }
    else
      render json: { errors: @device.errors, status: 500 }
    end
  end

  def update
    @device = Device.find(params[:id])
    if params[:image]
      @device.image.purge
      @device.image = ActiveStorage::Blob.find params[:image][:id]
      @device.save
    end
    if @device.update!(device_params)
      render json: { Device: @device, status: 200 }
    else
      render json: { errors: @device.errors, status: 500 }
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.image.purge
    if @device.destroy
      render json: { status: 200 }
    else
      render json: { errors: @Device.errors, status: 500 }
    end
  end

  private

  def device_params
    params.require(:device).permit(:name, :description, :image, :device_type_id)
  end
end
