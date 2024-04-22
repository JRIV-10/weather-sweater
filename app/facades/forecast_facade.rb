class ForecastFacade
  
  def self.forecast_location(location)
    ForecastService.city_coordinates(location)[:results][0][:locations][0][:latLng]
  end

  def self.weather_forecast(coords)
    data = ForecastService.forecast_data(coords)
    Forecast.new(data)
  end
end