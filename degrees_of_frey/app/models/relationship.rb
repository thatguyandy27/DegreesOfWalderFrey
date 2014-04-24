class Relationship < ActiveRecord::Base
  belongs_to :parent, :class_name => "Character"
  belongs_to :child, :class_name => "Character"

  validates :parent_id, :presence => true
  validates :child_id, :presence => true

  def self.find_relationship(character1, character2)
    return where('(parent_id = :id1 AND child_id = :id2) OR (parent_id = :id2 AND child_id = :id1)',
        {:id1 => character1.id, :id2 => character2.id}).first
  end

  def self.find_all_relationships(character)
    return where('parent_id = :id OR child_id = :id', {:id => character.id})
  end
end
