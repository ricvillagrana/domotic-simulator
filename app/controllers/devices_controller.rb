class DevicesController < ApplicationController
  def index
    @devices = Device.all.order(id: :desc)
  end

  def show
    @device = current_device
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
    if params[:image]
      current_device.image.purge
      current_device.image = ActiveStorage::Blob.find params[:image][:id]
      current_device.save
    end
    if current_device.update!(device_params)
      render json: { Device: current_device, status: 200 }
    else
      render json: { errors: current_device.errors, status: 500 }
    end
  end

  def destroy
    current_device.image.purge
    if current_device.destroy
      render json: { status: 200 }
    else
      render json: { errors: current_device.errors, status: 500 }
    end
  end

  def append_sensor
    unless current_device.interfaces.include?(Sensor.find(params[:sensor_id]))
      current_device.sensors.append(Sensor.find(params[:sensor_id]))
      current_device.save
    end
  end

  def remove_sensor
    current_device.sensors.delete(params[:sensor_id])
  end

  def append_actuator
    unless current_device.interfaces.include?(Actuator.find(params[:actuator_id]))
      current_device.actuators.append(Actuator.find(params[:actuator_id]))
      current_device.save
    end
  end

  def remove_actuator
    current_device.actuators.delete(params[:actuator_id])
  end

  def append_interface
    unless current_device.interfaces.include?(Interface.find(params[:interface_id]))
      current_device.interfaces.append(Interface.find(params[:interface_id]))
      current_device.save
    end
  end

  def remove_interface
    current_device.interfaces.delete(params[:interface_id])
  end

  def current_device
    Device.find(params[:id])
  end

  private

  def device_params
    params.require(:device).permit(:name, :description, :image, :device_type_id)
  end
end
