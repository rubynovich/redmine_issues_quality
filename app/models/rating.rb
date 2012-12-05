class Rating < ActiveRecord::Base
  unloadable
  acts_as_list  
  
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :issues, :dependent => :nullify
  
  def to_s
    name
  end
end
