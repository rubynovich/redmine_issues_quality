class AddRatingIdForIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :rating_id, :integer
  end

  def self.down
    remove_column :issues, :rating_id
  end
end
