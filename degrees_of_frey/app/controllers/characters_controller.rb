class CharactersController < ApplicationController

  def index
    @characters = Character.paginate(:page => params[:page])
  end

  def show
    @character = Character.find(params[:id])
  end

end