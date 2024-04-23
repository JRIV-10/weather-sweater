class Api::V1::MunchiesController < ApplicationController
  def index 
    # coords = ForecastFacade.forecast_location(params[:destination])
    # forecast = ForecastFacade.weather_forecast(coords)
    # require 'pry'; binding.pry
    service = YelpFacade.find_places(yelp_params)
  end

  private 

  def yelp_params
    params.permit(:destination, :food)
  end
end