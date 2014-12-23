class AddAttachmentPhotoToCiudades < ActiveRecord::Migration
  def self.up
    change_table :ciudades do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :ciudades, :photo
  end
end
