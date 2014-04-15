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

  Character.create!(:name => value['name'], :icon => value['image'], :page => key )
end
