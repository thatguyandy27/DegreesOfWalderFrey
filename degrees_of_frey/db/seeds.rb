# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

chracters = JSON.parse(File.read("#{Rails.root}/db/data/character_results.json"))

chracters.each do |key, value|
  
  Character.create!(:name => value['name'], 
    :icon => value['image'], :page => key ) unless Character.find_by_page(key)
end

characters.each do |key, value|
  parent =  Character.find_by_page(key)
  characters["relationships"].each do |character|
    child = Character.find_by_page(character)
    Relationship.create!(:parent_id => parent.id, :child_id => child.id) unless 
      Relationship.find_relationship(child.id, parent.id)
  end
end

house = JSON.parse(File.read("#{Rails.root}/db/data/house_results.json"))

house.each do |key, house|
  characters = house["characters"]

  characters.each_index do |index|
    parent = Character.find_by_page(chracters[index])
    (index +1).upto(chracters.size -1) do |i|
      child = Character.find_by_page(characters[i])
      Relationship.create!(:parent_id => parent.id, :child_id => child.id) unless 
        Relationship.find_relationship(child.id, parent.id) 
    end
  end
end
