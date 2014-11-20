class PromocionsController < ApplicationController
  before_action :set_promocion, only: [:show, :edit, :update, :destroy]

  # GET /promocions
  # GET /promocions.json
  def index
    @promocions = Promocion.all
  end

  # GET /promocions/1
  # GET /promocions/1.json
  def show
  end

  # GET /promocions/new
  def new
    @promocion = Promocion.new
  end

  # GET /promocions/1/edit
  def edit
  end

  # POST /promocions
  # POST /promocions.json
  def create
    @promocion = Promocion.new(promocion_params)

    respond_to do |format|
      if @promocion.save
        format.html { redirect_to @promocion, notice: 'Promocion was successfully created.' }
        format.json { render :show, status: :created, location: @promocion }
      else
        format.html { render :new }
        format.json { render json: @promocion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /promocions/1
  # PATCH/PUT /promocions/1.json
  def update
    respond_to do |format|
      if @promocion.update(promocion_params)
        format.html { redirect_to @promocion, notice: 'Promocion was successfully updated.' }
        format.json { render :show, status: :ok, location: @promocion }
      else
        format.html { render :edit }
        format.json { render json: @promocion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promocions/1
  # DELETE /promocions/1.json
  def destroy
    @promocion.destroy
    respond_to do |format|
      format.html { redirect_to promocions_url, notice: 'Promocion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promocion
      @promocion = Promocion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def promocion_params
      params.require(:promocion).permit(:idpromocion, :porcentaje, :fechaentrada, :vigencia)
    end
end
