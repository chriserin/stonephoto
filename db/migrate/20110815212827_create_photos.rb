class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.string :tag
      t.string :photo_file_file_name
      t.string :photo_file_content_type
      t.integer :photo_file_file_size
      t.datetime :photo_file_updated_at
      t.timestamps
    end
  end
end
