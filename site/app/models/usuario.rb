class Usuario < ActiveRecord::Base
	belongs_to :category
  
	has_attached_file :avatar, :styles => { :small => "150x150#>", :normal => "250x250#" },
						:default_url => "/assets/images/uss.jpg",
    					:hash_secret => "longSecretString",
	                    :url  => "/assets/usuarios/:style/:hash.:extension",
	                    :path => ":rails_root/public/assets/usuarios/:style/:hash.:extension"
	  
	validates_attachment_presence :avatar
	validates_attachment_size :avatar, :less_than => 5.megabytes
	validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']

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
