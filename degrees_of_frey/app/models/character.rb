class Character < ActiveRecord::Base
  has_many :relationships, :foreign_key => "parent_id"
  has_many :reverse_relationships, :class_name => "Relationship", :foreign_key => "child_id"

  has_many :children, :through => :relationships, :source => :child 
  has_many :parents, :through => :relationships, :source => :parent 
  
  validates(:name, :presence => true)
  validates(:page, :presence => true)

end
