class Usuario < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :nombres, use: :slugged
	validates_presence_of :correo 
end
