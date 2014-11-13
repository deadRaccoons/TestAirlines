class Nosotros::AvionesController < ApplicationController
  before_action :set_nosotros_avione, only: [:show, :edit, :update, :destroy]

  # GET /nosotros/aviones
  # GET /nosotros/aviones.json
  def index
    @nosotros_aviones = Nosotros::Avione.all
  end

  # GET /nosotros/aviones/1
  # GET /nosotros/aviones/1.json
  def show
     @nosotros_avione = Nosotros::Avione.find(params[:id])
  end

  # GET /nosotros/aviones/new
  def new
    @nosotros_avione = Nosotros::Avione.new
  end

  # GET /nosotros/aviones/1/edit
  def edit
  end

  # POST /nosotros/aviones
  # POST /nosotros/aviones.json
  def create
    @nosotros_avione = Nosotros::Avione.new(nosotros_avione_params)

    respond_to do |format|
      if @nosotros_avione.save
        format.html { redirect_to @nosotros_avione, notice: 'Avione was successfully created.' }
        format.json { render :show, status: :created, location: @nosotros_avione }
      else
        format.html { render :new }
        format.json { render json: @nosotros_avione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nosotros/aviones/1
  # PATCH/PUT /nosotros/aviones/1.json
  def update
    respond_to do |format|
      if @nosotros_avione.update(nosotros_avione_params)
        format.html { redirect_to @nosotros_avione, notice: 'Avione was successfully updated.' }
        format.json { render :show, status: :ok, location: @nosotros_avione }
      else
        format.html { render :edit }
        format.json { render json: @nosotros_avione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nosotros/aviones/1
  # DELETE /nosotros/aviones/1.json
  def destroy
    @nosotros_avione.destroy
    respond_to do |format|
      format.html { redirect_to nosotros_aviones_url, notice: 'Avione was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nosotros_avione
      @nosotros_avione = Nosotros::Avione.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nosotros_avione_params
      params[:nosotros_avione]
    end
end
