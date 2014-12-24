# -*- coding: utf-8 -*-
class LoginsController < ApplicationController
  before_action :set_login, only: [:show]

  # GET /logins
  # GET /logins.json
  def index
    if session[:current_user_id] != nil
      @usuario = Usuario.find(session[:current_user_id])
      redirect_to @usuario
    else
      @login = Login.new
      render 'new'
    end
  end

  # GET /logins/1
  # GET /logins/1.json
  def show
    @login = Login.find(login_params)
    if login_params
      render json: @login
    end
  end

  # GET /logins/new
  def new
    redirect_to "/usuarios/new"
  end

  # GET /logins/1/edit
  def edit
  end

  def intento_login

  end

  # POST /logins
  # POST /logins.json
  def create
    @login = Login.find_by_correo(login_params[:correo])
    secreto = Digest::SHA1.hexdigest(login_params[:secreto])

    if @login && @login.secreto == secreto
      @usuario = Usuario.find_by_correo(@login.correo)

      session[:current_user_id] = @usuario.id
      session[:current_user_mail] = @usuario.correo
      @usuario.friendly_id
      redirect_to @usuario
    else
      flash[:alert] = "Usuario o contraseña incorrecta"
      redirect_to "/logins"
    end

  end

  # PATCH/PUT /logins/1
  # PATCH/PUT /logins/1.json
  def update
    respond_to do |format|
      if @login.update(login_params)
        format.html { redirect_to @login, notice: 'Login was successfully updated.' }
        format.json { render :show, status: :ok, location: @login }
      else
        format.html { render :edit }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  def destroy
    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def logout
    if session[:current_user_id] != nil
      @login = Login.find_by_correo(session[:current_user_mail])
      
      if @login != nil
        @login.activo = "n"
        @login.save
      end

      session[:current_user_id] = nil
      session[:current_user_mail] = nil
    end
    redirect_to "/"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login
      @login = Login.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:login).permit(:correo, :secreto)
    end
end
