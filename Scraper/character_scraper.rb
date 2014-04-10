require 'nokogiri'
require 'open-uri'
require 'json'

class CharacterScraper

  ALL_CHARACTERS = 'http://awoiaf.westeros.org/index.php/List_of_Characters'
  BASE_URL = 'http://awoiaf.westeros.org'
  ALL_HOUSES = 'http://awoiaf.westeros.org/index.php/Minor_houses_in_A_Song_of_Ice_and_Fire'
  def initialize(character_hash)
    @characters = character_hash || Hash.new
    @houses = Hash.new
  end

  def get_characters
    get_chracters_from_page

    get_additional_information
  end

  def get_houses
    page = Nokogiri::HTML(open(ALL_HOUSES))
    get_houses_from_page(page)
    get_additional_house_information()
    return @houses
  end

  private 
    def get_additional_house_information()
      @houses.each do |key, value|
        get_house_information(key, value)
      end
    end

    def get_house_information(href, info)
      page = Nokogiri::HTML(open(BASE_URL + href))
      info[:characters] = []
      info[:overlord] = ''
      info_links = page.css('#bodyContent .infobox a')

      info_links.each do |a|
        if (@houses.has_key?(a[:href]))
          info[:overlord] = a[:href]
          break
        end
      end
      links = page.css("#bodyContent a")

      links.each do |link|
        info[:characters] << link[:href] if @characters.has_key?(link[:href])
      end

    end

    def get_houses_from_page(page)
      major_houeses = page.css('#bodyContent p:first a:nth-child(n+4)')
      major_houeses.each do |house|
        @houses[house[:href]] = {
          :name => house.text
        }
      end

      minor_houses = page.css("#bodyContent ul a")
      minor_houses.each do |house|
        @houses[house[:href]] = {:name => house.text}
      end
    end

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


def get_existing_characters
  file_data = File.read("character_results.json")
  return JSON.parse(file_data)
end

existing_characters = get_existing_characters()

scraper = CharacterScraper.new(existing_characters)

houses = scraper.get_houses()

file = File.open("house_results.json", "w")
file.write(houses.to_json)