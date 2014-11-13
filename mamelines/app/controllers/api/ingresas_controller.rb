class IngresasController < ApplicationController
  before_action :set_ingresa, only: [:show, :edit, :update, :destroy]

  # GET /ingresas
  # GET /ingresas.json
  def index
    @ingresas = Ingresa.all
  end

  # GET /ingresas/1
  # GET /ingresas/1.json
  def show
  end

  # GET /ingresas/new
  def new
    @ingresa = Ingresa.new
  end

  # GET /ingresas/1/edit
  def edit
  end

  # POST /ingresas
  # POST /ingresas.json
  def create
    @ingresa = Ingresa.new(ingresa_params)

    respond_to do |format|
      if @ingresa.save
        format.html { redirect_to @ingresa, notice: 'Ingresa was successfully created.' }
        format.json { render :show, status: :created, location: @ingresa }
      else
        format.html { render :new }
        format.json { render json: @ingresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingresas/1
  # PATCH/PUT /ingresas/1.json
  def update
    respond_to do |format|
      if @ingresa.update(ingresa_params)
        format.html { redirect_to @ingresa, notice: 'Ingresa was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingresa }
      else
        format.html { render :edit }
        format.json { render json: @ingresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingresas/1
  # DELETE /ingresas/1.json
  def destroy
    @ingresa.destroy
    respond_to do |format|
      format.html { redirect_to ingresas_url, notice: 'Ingresa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingresa
      @ingresa = Ingresa.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingresa_params
      params.require(:ingresa).permit(:correo, :contraseña, :activo)
    end
end
