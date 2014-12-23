class PromocionesController < ApplicationController
  before_action :set_promocione, only: [:show, :edit, :update, :destroy]

  # GET /promociones
  # GET /promociones.json
  def index
    @promociones = Promocione.all
  end

  # GET /promociones/1
  # GET /promociones/1.json
  def show
    @promocione = Promocione.friendly.find(params[:id])
  end

  # GET /promociones/new
  def new
    @promocione = Promocione.new
  end

  # GET /promociones/1/edit
  def edit
  end

  # POST /promociones
  # POST /promociones.json
  def create
    @promocione = Promocione.new(promocione_params)
    @promocione.save
    redirect_to @promocione
  end

  # PATCH/PUT /promociones/1
  # PATCH/PUT /promociones/1.json
  def update
    respond_to do |format|
      if @promocione.update(promocione_params)
        format.html { redirect_to @promocione, notice: 'Promocione was successfully updated.' }
        format.json { render :show, status: :ok, location: @promocione }
      else
        format.html { render :edit }
        format.json { render json: @promocione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promociones/1
  # DELETE /promociones/1.json
  def destroy
    @promocione.destroy
    respond_to do |format|
      format.html { redirect_to promociones_url, notice: 'Promocione was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promocione
      @promocione = Promocione.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def promocione_params
      params.require(:promocione).permit(:descripcion ,:vigencia, :ciudad, :codigopromocion, :iniciopromo, :finpromo, :photo)
    end
end
