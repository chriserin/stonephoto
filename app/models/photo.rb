class Photo < ActiveRecord::Base
  has_attached_file :photo_file, 
                    :storage => :s3,
                    :s3_credentials => S3_CREDENTIALS,
                    :path => 'stonephoto/photos/:basename_:style.:extension',
                    :bucket => 'chriserin_paperclip_test',
                    :styles => { :original => "100%", :big_display => "x600" , :medium => "x450", :thumb => "100x100>" }
  attr_accessor :medium_url

  after_post_process :save_image_dimensions

  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(photo_file.queued_for_write[:medium])
    self.image_width = geo.width
  end
end
