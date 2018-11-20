class NetworksController < ApplicationController
  def index
    @networks = Network.all.order(id: :desc)
  end

  def create
    @network = Network.new(network_params)
    @network.symbol = ActiveStorage::Blob.find params[:blob][:id] unless params[:blob].nil?
    if @network.save
      render json: { network: @network, status: 200 }
    else
      render json: { errors: @network.errors, status: 500 }
    end
  end

  def update
    @network = Network.find(params[:id])
    set_symbols(@network, params[:blobs])
    if @network.update!(network_params)
      render json: { network: @network, status: 200 }
    else
      render json: { errors: @network.errors, status: 500 }
    end
  end

  def destroy
    @network = Network.find(params[:id])
    if @network.destroy
      render json: { status: 200 }
    else
      render json: { errors: @network.errors, status: 500 }
    end
  end

  def set_symbols(network, blobs)
    network.symbol_off = ActiveStorage::Blob.find blobs[:symbol_off][:id] if blobs[:symbol_off]
    network.symbol_on = ActiveStorage::Blob.find blobs[:symbol_on][:id] if blobs[:symbol_on]
    network.symbol_error = ActiveStorage::Blob.find blobs[:symbol_error][:id] if blobs[:symbol_error]
    network.save
  end

  private

  def network_params
    params.require(:network).permit(:name, :description, :configuration)
  end
end
