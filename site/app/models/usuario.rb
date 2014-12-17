class Usuario < ActiveRecord::Base
	validates_presence_of :correo 
end
