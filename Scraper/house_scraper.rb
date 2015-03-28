require 'nokogiri'
require 'open-uri'
require 'json'

house_url = 'http://awoiaf.westeros.org/index.php/Houses_of_Westeros'

class HouseScraper

  ALL_CHARACTERS = 'http://awoiaf.westeros.org/index.php/List_of_Characters'
  BASE_URL = 'http://awoiaf.westeros.org'
  ALL_HOUSES = 'http://awoiaf.westeros.org/index.php/Houses_of_Westeros'

  def retrieve_house(url)
    if !url.start_with?(BASE_URL)
      url =   BASE_URL + url
    end
    page = Nokogiri::HTML(open(url))

    #this is the box in the top right
    infobox = page.at_css('.infobox')
    return nil if infobox.nil? 
    image = infobox.at_css(".infobox-image img")

    house = {}
    house[:name] = infobox.at_css('.infobox-above').text.sub(/house/i, '')
    house[:link] = url.gsub(/http:\/\/awoiaf.westeros.org/i, '')
    house[:lord] = ''
    house[:seat] = ''
    house[:region] = ''
    house[:image] = image && image[:src] || "none"
    house[:overlord] = 'none'
    house[:cadets] = []

    puts house[:name]

    info_rows = infobox.css('tr')
    info_rows.each do |row|
 
      label = row.at_css('th')
      value = row.at_css('td')

      next if label.nil? || label.text.nil? || value.nil?
      #puts label.text
      
      case label.text.downcase
        when 'seat'

          house[:seat] = value.text
        
        when 'current lord'
          if (value.text.downcase.include? ('unknown') or value.text.downcase.include? ('extinct'))
            house[:lord] = 'none'
          elsif !value.at_css('a').nil?
            house[:lord] = value.at_css('a')[:href]
          else
            house[:lord] = value.text
          end

        when 'region'
          if value.at_css('a').nil?
            house[:region] = 'exiled'
          else
            house[:region] = value.at_css('a')[:href]
          end
        when 'overlord'
          if !value.text.downcase.include? 'none' and !value.at_css('a').nil?
            house[:overlord] = value.at_css('a')[:href]
          end

        when 'cadet branch'
          cadets = value.css('a')

          cadets.each { |cadet| house[:cadets] << cadet[:href]}
      end
    end


    return house
  end

  def retrieve_all_houses (output_file_name)
     #.navbox-list a
     #find all the links and call retrieve_house on all of them
     page = Nokogiri::HTML(open(ALL_HOUSES))

     house_links = page.css(".navbox-list a")
     houses = []

     house_links.each do |link|
      house = retrieve_house(link[:href])

      houses << house if !house.nil?
     end

     file = File.open(output_file_name, "w")
     file.write(houses.to_json)
  end


end

scraper = HouseScraper.new

#if ARGV.count >= 1
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Reyne').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Stark').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Tully').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Baratheon_of_Dragonstone').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Baelish').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Baelish_of_Harrenhal').to_json
  # puts scraper.retrieve_house('http://awoiaf.westeros.org/index.php/House_Baratheon_of_King%27s_Landing').to_json

#else
scraper.retrieve_all_houses ('houses.json')
#end

