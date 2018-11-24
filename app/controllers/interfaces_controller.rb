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
    set_symbols(@interface, params[:blobs])
    if @interface.save
      render json: { interface: @interface, status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  def update
    @interface = Interface.find(params[:id])
    set_symbols(@interface, params[:blobs])
    if @interface.update!(interface_params)
      render json: { interface: @interface, status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  def destroy
    @interface = Interface.find(params[:id])
    purge_symbols(@interface)
    if @interface.destroy
      render json: { status: 200 }
    else
      render json: { errors: @interface.errors, status: 500 }
    end
  end

  def set_symbols(interface, blobs)
    interface.symbol_off = ActiveStorage::Blob.find blobs[:symbol_off][:id] if blobs[:symbol_off]
    interface.symbol_on = ActiveStorage::Blob.find blobs[:symbol_on][:id] if blobs[:symbol_on]
    interface.symbol_error = ActiveStorage::Blob.find blobs[:symbol_error][:id] if blobs[:symbol_error]
    interface.save
  end

  def purge_symbols(interface)
    interface.symbol_off.purge
    interface.symbol_on.purge
    interface.symbol_error.purge
  end

  private

  def interface_params
    params.require(:interface).permit(:name, :description, :network_id)
  end
end
