class Relationship < ActiveRecord::Base
  belongs_to :parent, :class_name => "Character"
  belongs_to :child, :class_name => "Character"

  validates :parent_id, :presence => true
  validates :child_id, :presence => true

  def self.find_relationship(character_id1, character_id2)
    return where('(parent_id = :id1 AND child_id = :id2) OR (parent_id = :id2 AND child_id = id1)',
        {:id1 => character_id1, :id2 => character_id2})
  end
end
