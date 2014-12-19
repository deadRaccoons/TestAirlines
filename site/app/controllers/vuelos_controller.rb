class VuelosController < ApplicationController
  before_action :set_vuelo, only: [:show, :edit, :update, :destroy]

  # GET /vuelos
  # GET /vuelos.json
  def index
    @vuelos = Vuelo.all
    render json: @vuelos
  end

  # GET /vuelos/1
  # GET /vuelos/1.json
  def show
  end

  # GET /vuelos/new
  def new
    @vuelo = Vuelo.new
  end

  # GET /vuelos/1/edit
  def edit
  end

  # POST /vuelos
  # POST /vuelos.json
  def create
    @vuelo = Vuelo.new(vuelo_params)

    respond_to do |format|
      if @vuelo.save
        format.html { redirect_to @vuelo, notice: 'Vuelo was successfully created.' }
        format.json { render :show, status: :created, location: @vuelo }
      else
        format.html { render :new }
        format.json { render json: @vuelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vuelos/1
  # PATCH/PUT /vuelos/1.json
  def update
    respond_to do |format|
      if @vuelo.update(vuelo_params)
        format.html { redirect_to @vuelo, notice: 'Vuelo was successfully updated.' }
        format.json { render :show, status: :ok, location: @vuelo }
      else
        format.html { render :edit }
        format.json { render json: @vuelo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vuelos/1
  # DELETE /vuelos/1.json
  def destroy
    @vuelo.destroy
    respond_to do |format|
      format.html { redirect_to vuelos_url, notice: 'Vuelo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vuelo
      @vuelo = Vuelo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vuelo_params
      params[:vuelo]
    end
end
