class Api::V1::MunchiesController < ApplicationController
  def index 
    service = ServicesFacade.find_places(yelp_params)
    require 'pry'; binding.pry
  end

  private 

  def yelp_params
    params.permit(:destination, :food)
  end
end