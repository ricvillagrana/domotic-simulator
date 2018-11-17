class FloorsController < ApplicationController
  def index
    @floors = Floor.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { floors: @floors, status: 200 } }
    end
  end

  def create
    @floor = Floor.new(floor_params)
    if @floor.save
      render json: { floor: @floor, status: 200 }
    else
      render json: { errors: @floor.errors, status: 500 }
    end
  end

  def update
    @floor = Floor.find(params[:id])
    if @floor.update!(floor_params)
      render json: { floor: @floor, status: 200 }
    else
      render json: { errors: @floor.errors, status: 500 }
    end
  end

  def destroy
    @floor = Floor.find(params[:id])
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
    params.require(:floor).permit(:name)
  end
end
