class NetworksController < ApplicationController
  def index
    @networks = Network.all.order(id: :desc)
  end

  def create
    @network = Network.new(network_params)
    @network.symbol = ActiveStorage::Blob.find params[:blob][:id]
    if @network.save
      render json: { network: @network, status: 200 }
    else
      render json: { errors: @network.errors, status: 500 }
    end
  end

  def update
    @network = Network.find(params[:id])
    @network.symbol = ActiveStorage::Blob.find params[:blob][:id]
    @network.save
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

  private

  def network_params
    params.require(:network).permit(:name, :description, :configuration)
  end
end
