class RoadTripFacade 
  def self.trip_details(params)
    start_coords = city_coords(params[:origin])
    end_coords = city_coords(params[:destination])
    
    start_trip(start_coords, end_coords, params[:origin], params[:destination])
  end

  def self.start_trip(start_coords, end_coords, origin, destination)
    directions = start_directions(start_coords, end_coords)
    forecast = ForecastFacade.raw_weather_forecast(end_coords)
    data = {
      directions: directions, 
      forecast: forecast, 
      origin: origin,
      destination: destination
    }
    
    RoadTrip.new(data)
  end

  def self.start_directions(start_coords, end_coords)
    RoadTripService.get_directions(start_coords, end_coords)
  end

  def self.city_coords(location)
    data = RoadTripService.city_coordinates(location)
    lat_lng = data[:results].first[:locations].first[:latLng]
  end
end