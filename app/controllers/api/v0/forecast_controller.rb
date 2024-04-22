class Api::V0::ForecastController < ApplicationController
  def index 
    coords = ForecastFacade.forecast_location(params[:location])
    forecast = ForecastFacade.weather_forecast(coords)
    render json: ForecastSerializer.new(forecast)
  end
end