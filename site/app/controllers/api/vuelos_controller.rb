class Api::VuelosController < ApplicationController
  before_action :set_api_vuelo, only: [:show, :edit, :update, :destroy]

  # GET /api/vuelos
  # GET /api/vuelos.json
  def index
    @api_vuelos = Api::Vuelo.all
  end

  # GET /api/vuelos/1
  # GET /api/vuelos/1.json
  def show
  end

  # GET /api/vuelos/new
  def new
    @api_vuelo = Api::Vuelo.new
  end

  # GET /api/vuelos/1/edit
  def edit
  end

  # POST /api/vuelos
  # POST /api/vuelos.json
  def create
    @api_vuelo = Api::Vuelo.new(api_vuelo_params)

    respond_to do |format|
      if @api_vuelo.save
        format.html { redirect_to @api_vuelo, notice: 'Vuelo was successfully created.' }
        format.json { render :show, status: :created, location: @api_vuelo }
      else
        format.html { render :new }
        format.json { render json: @api_vuelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/vuelos/1
  # PATCH/PUT /api/vuelos/1.json
  def update
    respond_to do |format|
      if @api_vuelo.update(api_vuelo_params)
        format.html { redirect_to @api_vuelo, notice: 'Vuelo was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_vuelo }
      else
        format.html { render :edit }
        format.json { render json: @api_vuelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/vuelos/1
  # DELETE /api/vuelos/1.json
  def destroy
    @api_vuelo.destroy
    respond_to do |format|
      format.html { redirect_to api_vuelos_url, notice: 'Vuelo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_vuelo
      @api_vuelo = Api::Vuelo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_vuelo_params
      params[:api_vuelo]
    end
end
