class Api::CiudadsController < ApplicationController
  before_action :set_api_ciudad, only: [:show]

  # GET /api/ciudads
  # GET /api/ciudads.json
  def index
    @ciudads = Ciudad.all
    render json: @ciudads
  end

  # GET /api/ciudads/1
  # GET /api/ciudads/1.json
  def show
  end

  # GET /api/ciudads/new
  def new
    @api_ciudad = Api::Ciudad.new
  end

  # GET /api/ciudads/1/edit
  def edit
  end

  # POST /api/ciudads
  # POST /api/ciudads.json
  def create
    @api_ciudad = Api::Ciudad.new(api_ciudad_params)

    respond_to do |format|
      if @api_ciudad.save
        format.html { redirect_to @api_ciudad, notice: 'Ciudad was successfully created.' }
        format.json { render :show, status: :created, location: @api_ciudad }
      else
        format.html { render :new }
        format.json { render json: @api_ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/ciudads/1
  # PATCH/PUT /api/ciudads/1.json
  def update
    respond_to do |format|
      if @api_ciudad.update(api_ciudad_params)
        format.html { redirect_to @api_ciudad, notice: 'Ciudad was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_ciudad }
      else
        format.html { render :edit }
        format.json { render json: @api_ciudad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/ciudads/1
  # DELETE /api/ciudads/1.json
  def destroy
    @api_ciudad.destroy
    respond_to do |format|
      format.html { redirect_to api_ciudads_url, notice: 'Ciudad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_ciudad
      @api_ciudad = Api::Ciudad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_ciudad_params
      params[:api_ciudad]
    end
end
