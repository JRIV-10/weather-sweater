class TripFacade 
  def self.trip_details(params)
    start_coords = city_coords(params[:start_city])
    end_coords = city_coords(params[:end_city])
    start_trip(start_coords, end_coords, params[:start_city], params[:end_city])
  end

  def self.start_trip(start_coords, end_coords, start_city, end_city)
    directions = start_directions(start_coords, end_coords)
    forecast = ForecastFacade.weather_forecast(end_coords)
    data = {
      directions: directions, 
      forecast: forecast, 
      start_city: start_city,
      end_city: end_city
    }
    Trip.new(data)
  end

  def self.start_directions(start_coords, end_coords)
    TripService.get_directions(start_coords, end_coords)
  end

  def self.city_coords(location)
    data = TripService.city_coordinates(location)
    parse_coords(data)
  end

  def parse_coords(data)
    lat = data[:results].first[:locations].first[:latLng][:lat]
    lng = data[:results].first[:locations].first[:latLng][:lng]
    "#{lat},#{lng}"
  end
end