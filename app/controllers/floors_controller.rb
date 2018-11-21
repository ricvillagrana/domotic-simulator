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
    @floor = Floor.find(params[:id])
    if params[:background]
      @floor.background.purge
      @floor.background = ActiveStorage::Blob.find params[:background][:id]
      @floor.save
    end
    if @floor.update!(floor_params)
      render json: { floor: @floor, status: 200 }
    else
      render json: { errors: @floor.errors, status: 500 }
    end
  end

  def destroy
    @floor = Floor.find(params[:id])
    @floor.background.purge
    if @floor.destroy
      render json: { status: 200 }
    else
      render json: { errors: @floor.errors, status: 500 }
    end
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
