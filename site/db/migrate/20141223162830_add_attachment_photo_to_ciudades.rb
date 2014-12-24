class AddAttachmentPhotoToCiudades < ActiveRecord::Migration
  def self.up
    change_table :ciudad do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :ciudad, :photo
  end
end
