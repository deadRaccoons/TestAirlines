class ViajesController < ApplicationController
  before_action :set_viaje, only: [:show,]

  # GET /viajes
  # GET /viajes.json
  def index
    @viajes = Viaje.all
    render json: @viajes
  end

  def detalles_dia
    @viajes = Viaje.where("fechasalida >= ?", params[:date])
    render json: @viajes
  end

  def detalles_vuelo
    @viajes = Viaje.where("fechasalida >= ?", params[:date])
    render json: @viajes
  end

  def llegadas
    @viajes = Viaje.where("destino  LIKE ?", "%" + params[:ciudad]+ "%")
    render "new"

  end

  def search
    sql = "(select nombre from ciudades where iata = ?)".to_s
    sql = sql + " = origen and (select nombre from ciudades where iata = ?) = ".to_s 
    sql = sql + " destino and fechasalida >= ? and realizado <> 'y'".to_s
    #render json: sql

    @viajes = Viaje.where(sql, params[:originIATA],params[:destinyIATA], params[:departureDate])
    render json: @viajes
  end 

  def sugerencias 
    @viajes = Viaje.all
    render json: @viajes
  end

  # GET /viajes/1
  # GET /viajes/1.json
  def show
     @viajes = Viaje.find(params[:id])
    render json: @viajes
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_viaje
      @viaje = Viaje.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def viaje_params
      params.require(:viaje).permit(:id,:date)
    end
end
