class Ciudade < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :nombre, use: :slugged

	def slug_candidates
		[
			[:nombre, :pais],
		]
	end
end
