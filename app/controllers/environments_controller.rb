class EnvironmentsController < ApplicationController
  def index
    @environments = Environment.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { environments: @environments, status: 200 }, include: [:unit_type] }
    end
  end

  def create
    @environment = Environment.new(environment_params)
    if @environment.save
      render json: { environment: @environment, status: 200 }
    else
      render json: { errors: @environment.errors, status: 500 }
    end
  end

  def update
    @environment = Environment.find(params[:id])
    if @environment.update!(environment_params)
      render json: { environment: @environment, status: 200 }
    else
      render json: { errors: @environment.errors, status: 500 }
    end
  end

  def destroy
    @environment = Environment.find(params[:id])
    if @environment.destroy
      render json: { status: 200 }
    else
      render json: { errors: @environment.errors, status: 500 }
    end
  end

  private

  def environment_params
    params.require(:environment).permit(:name, :default, :minimum, :maximum, :tendence, :time_to_tendence, :unit_type_id)
  end
end
