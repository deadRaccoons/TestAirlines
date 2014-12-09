class Api::AvionesController < ApplicationController
  before_action :set_api_avione, only: [:show, :edit, :update, :destroy]

  # GET /api/aviones
  # GET /api/aviones.json
  def index
    @api_aviones = Avion.all
    render json: @api_aviones
  end

  # GET /api/aviones/1
  # GET /api/aviones/1.json
  def show
  end

  # GET /api/aviones/new
  def new
    @api_avione = Api::Avione.new
  end

  # GET /api/aviones/1/edit
  def edit
  end

  # POST /api/aviones
  # POST /api/aviones.json
  def create
    @api_avione = Api::Avione.new(api_avione_params)

    respond_to do |format|
      if @api_avione.save
        format.html { redirect_to @api_avione, notice: 'Avione was successfully created.' }
        format.json { render :show, status: :created, location: @api_avione }
      else
        format.html { render :new }
        format.json { render json: @api_avione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/aviones/1
  # PATCH/PUT /api/aviones/1.json
  def update
    respond_to do |format|
      if @api_avione.update(api_avione_params)
        format.html { redirect_to @api_avione, notice: 'Avione was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_avione }
      else
        format.html { render :edit }
        format.json { render json: @api_avione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/aviones/1
  # DELETE /api/aviones/1.json
  def destroy
    @api_avione.destroy
    respond_to do |format|
      format.html { redirect_to api_aviones_url, notice: 'Avione was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_avione
      @api_avione = Api::Avione.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_avione_params
      params[:api_avione]
    end
end
