class Promocione < ActiveRecord::Base
	belongs_to :category
  
	has_attached_file :photo, :styles => { :small => "250x250>" },
	                    :url  => "/assets/promociones/:id/:style/:basename.:extension",
	                    :path => ":rails_root/public/assets/promociones/:id/:style/:basename.:extension"
	  
	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
	
	#pretty url for promotions	
	extend FriendlyId
  	friendly_id :codigopromocion, use: :slugged
  	
  	#ensure uniqueness for the url-id
	def slug_candidates
		[
			[:ciudad, :codigopromocion],
		]
	end

	
end
