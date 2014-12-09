class WelcomeController < ApplicationController
  def index
  	@usuario = nil
  	if (session[:current_user_id] != nil)
  		 @usuario = Usuario.find(session[:current_user_id])
  	end

  end
end
