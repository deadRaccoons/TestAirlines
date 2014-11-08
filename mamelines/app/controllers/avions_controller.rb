class AvionsController < ApplicationController
  before_action :set_avion, only: [:show, :edit, :update, :destroy]

  # GET /avions
  # GET /avions.json
  def index
    @avions = Avion.all
  end

  # GET /avions/1
  # GET /avions/1.json
  def show
  end

  # GET /avions/new
  def new
    @avion = Avion.new
  end

  # GET /avions/1/edit
  def edit
  end

  # POST /avions
  # POST /avions.json
  def create
    @avion = Avion.new(avion_params)

    respond_to do |format|
      if @avion.save
        format.html { redirect_to @avion, notice: 'Avion was successfully created.' }
        format.json { render :show, status: :created, location: @avion }
      else
        format.html { render :new }
        format.json { render json: @avion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /avions/1
  # PATCH/PUT /avions/1.json
  def update
    respond_to do |format|
      if @avion.update(avion_params)
        format.html { redirect_to @avion, notice: 'Avion was successfully updated.' }
        format.json { render :show, status: :ok, location: @avion }
      else
        format.html { render :edit }
        format.json { render json: @avion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /avions/1
  # DELETE /avions/1.json
  def destroy
    @avion.destroy
    respond_to do |format|
      format.html { redirect_to avions_url, notice: 'Avion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_avion
      @avion = Avion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def avion_params
      params.require(:avion).permit(:idavion, :modelo, :marca, :capacidadprimera, :capacidadturista, :disponible)
    end
end
