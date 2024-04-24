class RoadTripFacade 
  def self.trip_details(params)
    start_coords = city_coords(params[:start_city])
    end_coords = city_coords(params[:end_city])
    # require 'pry'; binding.pry
    start_trip(start_coords, end_coords, params[:start_city], params[:end_city])
  end

  def self.start_trip(start_coords, end_coords, start_city, end_city)
    directions = start_directions(start_coords, end_coords)
    forecast = ForecastFacade.raw_weather_forecast(end_coords)
    data = {
      directions: directions, 
      forecast: forecast, 
      start_city: start_city,
      end_city: end_city
    }
    # require 'pry'; binding.pry
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