require 'json'

class House

  def initialize()

    @characters = Array.new
    @potential_matches = Hash.new {|hash, key| hash[key] = []}

  end

  def find_missing_houses(chracter_file, output_file)
    load_file (chracter_file)
      
      #casecomp
    @characters.each do |char|

      if char["house"].nil? || char["house"].empty? || char["house"].casecmp('none') == 0
        # puts char["house"].nil?
        # puts char["house"].empty?
        # puts char["house"].casecmp('none')

        #puts char["house"]
        name_split = char["name"].split(' ')
        if (name_split.count == 2)
          # puts char['name']
          @potential_matches[name_split[1]] << char
        end

      end
    end


    file = File.open(output_file, "w")

    @potential_matches.each do |key, matches|

      matches.each do |match| 
        id = match["id"]
        name = match["name"]
        link = match["link"].chomp
        file.puts("#{key},#{name},#{link},#{id}")
      end

    end
  end

  private

    def load_file(character_file)
      file_data = File.read(character_file)
      @characters = JSON.parse(file_data)

    end

end

base_dir = '../../Portfolio/app/data/got/'
file = ''


house = House.new

house.find_missing_houses "#{base_dir}/nodes.json", "missing_houses.csv"