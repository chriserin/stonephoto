class WelcomeController < ApplicationController
  def index
    @photos = Photo.order("rank DESC").where("front_page = ?", true) 
  end

end
