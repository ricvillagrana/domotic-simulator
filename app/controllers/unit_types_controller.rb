class UnitTypesController < ApplicationController
  def index
    @unit_types = UnitType.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { unit_types: @unit_types, status: 200 } }
    end
  end

  def create
    @unit_type = UnitType.new(unit_type_params)
    if @unit_type.save
      render json: { unit_type: @unit_type, status: 200 }
    else
      render json: { errors: @unit_type.errors, status: 500 }
    end
  end

  def update
    @unit_type = UnitType.find(params[:id])
    if @unit_type.update!(unit_type_params)
      render json: { unit_type: @unit_type, status: 200 }
    else
      render json: { errors: @unit_type.errors, status: 500 }
    end
  end

  def destroy
    @unit_type = UnitType.find(params[:id])
    if @unit_type.destroy
      render json: { status: 200 }
    else
      render json: { errors: @unit_type.errors, status: 500 }
    end
  end

  private

  def unit_type_params
    params.require(:unit_type).permit(:description, :unit, :symbol, :network_id)
  end
end
