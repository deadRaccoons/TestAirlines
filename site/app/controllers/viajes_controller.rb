class ViajesController < ApplicationController
  before_action :set_viaje, only: [:show,]

  # GET /viajes
  # GET /viajes.json
  def index
    @viajes = Viaje.all
    render json: @viajes
  end

  # GET /viajes/1
  # GET /viajes/1.json
  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_viaje
      @viaje = Viaje.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viaje_params
      params[:viaje]
    end
end
