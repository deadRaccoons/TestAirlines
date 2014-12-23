class Usuario < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :nombres, use: :slugged
	validates_presence_of :correo 

	def slug_candidates
		[
			[:nombres, :apellidopaterno],
			[:nomres, :apellidopaterno, :apellidomaterno]
		]
	end
end
