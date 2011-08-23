class PhotoRank < ActiveRecord::Migration
  def up
    add_column :photos, :rank, :integer
  end

  def down
    remove_column :photos, :rank
  end
end
