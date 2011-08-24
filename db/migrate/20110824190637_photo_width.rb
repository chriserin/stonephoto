class PhotoWidth < ActiveRecord::Migration
  def up
    add_column :photos, :image_width, :integer
  end

  def down
    remove_column :photos, :image_width
  end
end
