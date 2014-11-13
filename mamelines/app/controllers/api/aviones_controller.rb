class Api::AvionesController < ApplicationController
	def index
    	@aviones = Avion.all
    	render json: @aviones
  	end
end
