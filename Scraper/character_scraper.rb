require 'nokogiri'
require 'open-uri'
require 'json'

class CharacterScraper

  ALL_CHARACTERS = 'http://awoiaf.westeros.org/index.php/List_of_Characters'
  BASE_URL = 'http://awoiaf.westeros.org'
  def get_characters
    @characters = Hash.new

    get_chracters_from_page

    get_additional_information
  end




  private 
    def get_chracters_from_page
        page = Nokogiri::HTML(open(ALL_CHARACTERS))
        chars = page.css('#bodyContent li > a:first-child')
        chars.each{ |char| @characters[char[:href]] = {:name=>char.text} }
    end

    def get_additional_information
        @characters.each do |key, value|
          get_character_information(key, value)
        end
    end

    def get_character_information(href, info)
      character_page = Nokogiri::HTML(open(BASE_URL + href))
      image = character_page.at_css(".infobox-image img")
      
      info[:image] = image && image[:src] || "none"
      info[:relationships] = []

      links = character_page.css("a")

      links.each do |link|
        info[:relationships] << link[:href] if @characters.has_key?(link[:href])
      end

    end
end




characters = CharacterScraper.new.get_characters
file = File.open("character_results.json", "w")
file.write(characters.to_json)