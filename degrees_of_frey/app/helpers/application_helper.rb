module ApplicationHelper

  def get_image_url(image)
    full_url = image
    if (!image || image == 'none')
      full_url = 'http://awoiaf.westeros.org/images/3/3a/Seven_Kingdoms.png'
    elsif !image.starts_with?('http://')
      full_url = 'http://awoiaf.westeros.org' + image
    end

    return full_url

  end

  def get_wiki_url(character)
    return 'http://awoiaf.westeros.org' + character.page
  end
end
