class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]


  # GET /usuarios
  # GET /usuarios.json
  def index
    if (session[:current_user_id] != nil)
        @usuario = Usuario.find(session[:current_user_id])
        redirect_to @usuario
    else
      redirect_to "/logins"
    end

  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
    if (session[:current_user_id] != nil)
      @muse = true;
      @usuario = Usuario.find(session[:current_user_id])
      if (@usuario == nil)
        redirect_to "/logins"
      end
    else
      redirect_to "/logins"
    end

  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end


  # GET /usuarios/1/edit
  def edit
    @edit = true
    @usuario = Usuario.find(session[:current_user_id])
    render "show"

  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)
    @login = Login.new
    @login.correo = params[:usuario][:correo]
    @login.secreto = Digest::SHA1.hexdigest(params[:usuario][:secreto])
    @login.activo = 'y'
    
    error = false
      @login.save && @usuario.save  

    begin

     rescue Exception => e
      error = true
      @login.destroy
      flash[:alert] = e.to_s
    end 

    if !error
      session[:current_user_id] = @usuario.id
      flash[:alert] = "Bienvenido a bordo!"
      redirect_to @usuario
    else
      @login.destroy
      render "new"
    end
  
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
      @usuario = Usuario.new(usuario_params)
      @old_user = Usuario.find(session[:current_user_id])
      @old_user.avatar = @usuario.avatar
      if @old_user.save
        redirect_to @old_user
      end

  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'Usuario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def historial
    @usuario = Usuario.find(session[:current_user_id])
    @historial = @usuario
    render "show"

  end 

  def destinos
    @usuario = Usuario.find(session[:current_user_id])
    @destinos = Ciudade.all
    render "show"
  end


  def promos
        @usuario = Usuario.find(session[:current_user_id])

    @promos = "ok"
    render "show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(session[:current_user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit(:correo, :nombres, :apellidopaterno, :apellidomaterno, :nacionalidad, :genero, :fechanacimiento, :avatar)

    end
end
