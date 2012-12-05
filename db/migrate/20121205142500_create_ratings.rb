class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :name, :string
      t.column :position, :integer, :default => 1
    end
  end

  def self.down
    drop_table :ratings
  end
end
