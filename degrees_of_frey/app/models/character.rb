class Character < ActiveRecord::Base

  validates(:name, :presence => true)
  validates(:page, :presence => true)

end
