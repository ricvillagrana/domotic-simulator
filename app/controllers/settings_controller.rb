class SettingsController < ApplicationController
  def index
    @settings = Setting.all
    respond_to do |format|
      format.json { render json: { settings: @settings, status: 200 } }
    end
  end

  def show
    render json: { setting: Setting.where(name: params[:id]).first, status: 200 }
  end

  def create
    if Setting.where(name: params[:name]).empty?
      @setting = Setting.new(setting_params)
    else
      @setting = current_setting
      @setting.data = params[:data]
    end
    if @setting.save
      render json: { setting: @setting, status: 200 }
    end
  end

  def destroy
    if current_setting.destroy
      render json: { status: 200 }
    end
  end

  def current_setting
    Setting.where(name: params[:name]).first
  end

  private

  def setting_params
    params.require(:setting).permit(:name, :data)
  end
end
