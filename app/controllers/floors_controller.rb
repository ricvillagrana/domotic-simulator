class FloorsController < ApplicationController
  def index
    @floors = Floor.all.order(id: :desc)
  end

  def create
    @floor = Floor.new(floor_params)
    @floor.background = ActiveStorage::Blob.find params[:background][:id] if params[:background]

    if @floor.save
      render json: { floor: @floor, status: 200 }
    else
      render json: { errors: @floor.errors, status: 500 }
    end
  end

  def update
    if params[:background]
      current_floor.background.purge
      current_floor.background = ActiveStorage::Blob.find params[:background][:id]
      current_floor.save
    end
    if current_floor.update!(floor_params)
      render json: { floor: current_floor, status: 200 }
    else
      render json: { errors: current_floor.errors, status: 500 }
    end
  end

  def destroy
    current_floor.background.purge
    current_floor.rooms.each {|room| room.destroy}
    if current_floor.destroy
      render json: { status: 200 }
    else
      render json: { errors: current_floor.errors, status: 500 }
    end
  end

  def rooms
    @rooms = current_floor.rooms
  end

  def current_floor
    Floor.find(params[:id])
  end

  def next_position
    return 1 if Floor.all.size == 0
    last = Floor.order(position: :asc).last.position
    last ? last + 1 : 1
  end

  private

  def floor_params
    params.require(:floor).permit(:name, :background)
  end
end
