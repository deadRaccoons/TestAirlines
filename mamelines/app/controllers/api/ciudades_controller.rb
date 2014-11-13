class Api::CiudadesController < ApplicationController
	def index
    	@ciudades = Ciudad.all
    	render json: @ciudades
  	end

  	def show
  	 @post = Ciudad.find(params[:id])
  	 render json: @post

  	end
end
