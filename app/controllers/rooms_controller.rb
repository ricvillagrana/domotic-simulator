class RoomsController < ApplicationController
  def index
    @rooms = Room.all.order(id: :desc)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: { room: current_room, status: 200 }, include: [:environments, :devices] }
    end
  end

  def create
    @room = Room.new(room_params)
    @room.background = ActiveStorage::Blob.find params[:background][:id] if params[:background]
    fill_serialized(@room, params)
    if @room.save
      render json: { Room: @room, status: 200 }
    else
      render json: { errors: @room.errors, status: 500 }
    end
  end

  def update
    if params[:background]
      current_room.background.purge
      current_room.background = ActiveStorage::Blob.find params[:background][:id]
      current_room.save
    end
    if current_room.update!(room_params)
      fill_serialized(current_room, params)
      render json: { Room: current_room, status: 200 }
    else
      render json: { errors: current_room.errors, status: 500 }
    end
  end

  def destroy
    current_room.background.purge
    if current_room.destroy
      render json: { status: 200 }
    else
      render json: { errors: @Room.errors, status: 500 }
    end
  end

  def devices
    devices = Device.all.map { |device| device.environments.all? { |env| current_room.environments.include?(env) } ? device : nil}
    devices.delete nil
    respond_to do |format|
      format.html
      format.json { render json: { devices: devices, status: 200 } }
    end
  end

  def current_room
    Room.find(params[:id])
  end

  def fill_serialized(room, params)
    room.sizes = JSON.parse(params[:sizes]) if params[:sizes]
    room.position = JSON.parse(params[:position]) if params[:position]
    room.color = JSON.parse(params[:color]) if params[:color]
    room.save
  end

  def next_position
    return 1 if Room.all.size == 0
    last = Room.order(position: :asc).last.position
    last ? last + 1 : 1
  end

  def append_environment
    env = Environment.find(params[:environment_id])
    current_room.environments.append(env)
    current_room.save
  end

  def remove_environment
    current_room.environments.delete(params[:environment_id])
    current_room.save
  end

  def append_device
    device = Device.find(params[:device_id])
    current_room.devices.append(device)
    current_room.save
  end

  def remove_device
    current_room.devices.delete(params[:device_id])
    current_room.save
  end

  private

  def room_params
    params.require(:room).permit(:name, :sizes, :position, :color, :background, :floor_id)
  end
end
