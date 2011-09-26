require 'ostruct'
class WelcomeController < ApplicationController
  def index
    @page_title = "Starzucks Coffee"
    @people = users
  end
end
