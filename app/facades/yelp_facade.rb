class YelpFacade 
  def self.find_places(params)
    place = YelpService.search(params)
    {
      destination: params[:destination],
      forecast: yelp_forecast(params[:destination])
    }
    # require 'pry'; binding.pry
  end

  def self.yelp_forecast(location)
    coords = ForecastFacade.forecast_location(location)
    forecast = ForecastFacade.weather_forecast(coords)
  end
end