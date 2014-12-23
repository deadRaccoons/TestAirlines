class Promocione < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :ciudad, use: :slugged

	def slug_candidates
		[
			[:ciudad, :codigopromocion],
		]
	end
end
