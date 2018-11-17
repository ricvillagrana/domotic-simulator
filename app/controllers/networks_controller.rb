class NetworksController < ApplicationController
  def index
    @networks = Network.all
    respond_to do |format|
      format.html
      format.json { render json: { networks: @networks, status: 200 } }
    end
  end

  def create
    @network = Network.new(network_params)
    if @network.save
      render json: { network: @network, status: 200 }
    else
      render json: { errors: @network.errors, status: 500 }
    end
  end

  def update
    @network = Network.find(params[:id])
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
