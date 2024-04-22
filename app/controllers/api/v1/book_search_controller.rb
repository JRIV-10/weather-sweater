class Api::V1::BookSearchController < ApplicationController
  def index
    location = params[:location]
    quantity = params[:quantity].to_i
    forecast = get_forecast(location)
    # require 'pry'; binding.pry
    books = BookSearchFacade.search_books(location, quantity, forecast)
    render BookSearchSerializer.new(books)
  end

  private 

  def get_forecast(location)
    coords = ForecastFacade.forecast_location(location)
    # require 'pry'; binding.pry
    forecast = ForecastFacade.weather_forecast(coords)
    ForecastSerializer.new(forecast)
  end
end