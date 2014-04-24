# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

characters = JSON.parse(File.read("#{Rails.root}/db/data/character_results.json"))

characters.each do |key, value|
  
  Character.create!(:name => value['name'], 
    :icon => value['image'], :page => key ) unless Character.find_by_page(key)
end

characters.each do |key, value|
  parent =  Character.find_by_page(key)
  relationships = value["relationships"]

  if relationships
    relationships.each do |character|
      child = Character.find_by_page(character)
      puts "#{parent.name}: #{child.name}"
      if !Relationship.find_relationship(child, parent) 
        Relationship.create!(:parent_id => parent.id, :child_id => child.id) 
      end
    end
  end
end

house = JSON.parse(File.read("#{Rails.root}/db/data/house_results.json"))

house.each do |key, house|
  house_characters = house["characters"]
  max = house_characters.size - 1
  house_characters.each_index do |index|
    #puts "#{index} => #{house_characters[index]}"
    parent = Character.find_by_page(house_characters[index])
    (index + 1).upto(max) do |i|
      child = Character.find_by_page(house_characters[i])
      if !Relationship.find_relationship(child, parent) 
        Relationship.create!(:parent_id => parent.id, :child_id => child.id) 
      end
    end
  end
end
