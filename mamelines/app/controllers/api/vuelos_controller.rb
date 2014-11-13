class Api::VuelosController < ApplicationController
	def index
    	@vuelos = Vuelo.all
    	render json: @vuelos
  	end
end
