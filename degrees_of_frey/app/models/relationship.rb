class Relationship < ActiveRecord::Base
  belongs_to :parent, :class_name => "Character"
  belongs_to :child, :class_name => "Character"

  valdiates :parent_id, :presence => true
  validates :child_id, :presence => true

end
