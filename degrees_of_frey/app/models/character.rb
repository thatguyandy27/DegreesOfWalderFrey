class Character < ActiveRecord::Base
  has_many :relationships, :foreign_key => "parent_id", :dependent => :destroy
  has_many :reverse_relationships, :class_name => "Relationship", :foreign_key => "child_id", :dependent => :destroy

  has_many :children, :through => :relationships, :source => :child 
  has_many :parents, :through => :reverse_relationships, :source => :parent 
  
  validates(:name, :presence => true)
  validates(:page, :presence => true)

  def all_relationships
    return Relationships.find_all_relationships(self)
  end
end
