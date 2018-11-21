class RoomsController < ApplicationController
  def index
    @rooms = Room.all.order(id: :desc)
  end

  def show
    @floor = Floor.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: { rooms: @floor.rooms, status: 200 } }
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
    @room = Room.find(params[:id])
    if params[:background]
      @room.background.purge
      @room.background = ActiveStorage::Blob.find params[:background][:id]
      @room.save
    end
    if @room.update!(room_params)
      fill_serialized(@room, params)
      render json: { Room: @room, status: 200 }
    else
      render json: { errors: @room.errors, status: 500 }
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.background.purge
    if @room.destroy
      render json: { status: 200 }
    else
      render json: { errors: @Room.errors, status: 500 }
    end
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

  private

  def room_params
    params.require(:room).permit(:name, :sizes, :position, :color, :background, :floor_id)
  end
end
