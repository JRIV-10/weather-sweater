class YelpFacade 
  def self.find_places(params)
    data = YelpService.search(params)
    restaurant_data = extract_restaurant_data(data)
    {
      destination_city: params[:destination],
      forecast: parsed_forecast(params[:destination]),
      restaurant: one_restaurant(restaurant_data)
    }
  end

  def self.yelp_forecast(location)
    coords = ForecastFacade.forecast_location(location)
    forecast = ForecastFacade.weather_forecast(coords)
  end

  def self.parsed_forecast(location)
    current_forecast = yelp_forecast(location).current_weather
    {
      summary: current_forecast[:condition],
      temperature: current_forecast[:temperature]
    }
  end

  def self.one_restaurant(place)
    Yelp.new(place)
  end

  def self.extract_restaurant_data(data)
    data[:businesses].first
  end
end