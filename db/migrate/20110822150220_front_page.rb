class FrontPage < ActiveRecord::Migration
  def up
    add_column :photos, :front_page, :boolean
  end

  def down
    remove_column :photos, :front_page 
  end
end
