require 'nokogiri'
require 'open-uri'
require 'json'

class CharacterScraper

  BASE_URL = 'http://awoiaf.westeros.org'


  def initialize(node_file, link_file)

    @characters = Array.new
    @links = Array.new
    @node_file = node_file
    @link_file = link_file
  end

  def find_missing_characters(missing_list)
    load_files

    missing_list.each do |link|
      puts link
      if (!@characters.any? { |exist_char| exist_char[:link] == link })
        new_char = {}
        new_char[:id] = @characters.count
        new_char[:link] = link
        get_character_information(link, new_char)
        @characters << new_char
      end 

    end

    #export files back to json yo!
    file = File.open(@node_file, "w")
    file.write(@characters.to_json)

  end

  private
    def get_character_information(href, info)
      character_page = Nokogiri::HTML(open(BASE_URL + href))
      image = character_page.at_css(".infobox-image img")
      
      info[:name] = character_page.at_css("#firstHeading").text
      info[:image] = image && image[:src] || "none"
      info[:house] = 'none'

      #links = character_page.css("a")

      # links.each do |link|
      #   # need to add all the links here.
      #   linked_char = @chracters.find{ |char| char.link == link}
      #   if linked_char

      #   else
      #     puts "No char found with URL: " + link
          
      # end
    end


    def load_files
      file_data = File.read(@node_file)
      @characters = JSON.parse(file_data)

      # file_data = File.read(@link_file)
      # @links = JSON.parse(file_data)
    end

end

base_dir = '../../Portfolio/app/data/got/'

scraper = CharacterScraper.new  "#{base_dir}/nodes.json", "#{base_dir}/links.json" 

missing_data = File.open('./missing.dat', 'r').readlines

scraper.find_missing_characters missing_data