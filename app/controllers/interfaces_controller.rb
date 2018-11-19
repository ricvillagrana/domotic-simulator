class InterfacesController < ApplicationController
  def index
    @interfaces = Interface.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: { interfaces: @interfaces, status: 200 }, include: ['network'] }
    end
  end

  def create
    @interface = Interface.new(interface_params)
    if @interface.save
      render json: { interface: @interface, status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  def update
    @interface = Interface.find(params[:id])
    if @interface.update!(interface_params)
      render json: { interface: @interface, status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  def destroy
    @interface = Interface.find(params[:id])
    if @interface.destroy
      render json: { status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  private

  def interface_params
    params.require(:interface).permit(:name, :description, :network_id)
  end
end
