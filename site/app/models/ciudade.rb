class Ciudade < ActiveRecord::Base
	belongs_to :category
  
	has_attached_file :photo, :styles => { :small => "250x250>" },
						:default_url => "/assets/images/hp.jpg",
	                    :url  => "/assets/promociones/:id/:style/:basename.:extension",
	                    :path => ":rails_root/public/assets/promociones/:id/:style/:basename.:extension"
	  
	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

	extend FriendlyId
  	friendly_id :nombre, use: :slugged

	def slug_candidates
		[
			[:nombre, :pais],
		]
	end
end
