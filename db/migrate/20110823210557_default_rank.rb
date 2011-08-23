class DefaultRank < ActiveRecord::Migration
  def up
    remove_column :photos, :rank
    add_column :photos, :rank, :integer, default: 0
  end

  def down
    remove_column :photos, :rank
    add_column :photos, :rank, :integer
  end
end
