class TripService 
  def self.city_coordinates(location)
    get_url_geolocation("/geocoding/v1/address", location: location)
  end

  def self.conn_geolocation
    Faraday.new(url:"https://mapquestapi.com") do |faraday|
      faraday.params['key'] = Rails.application.credentials.geolocation_api_key[:key]
    end
  end

  def self.get_url_geolocation(url, params) 
    response = conn_geolocation.get(url, params)
    data = JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_directions(start_coords, end_coords)
    response = get_directions_url(start_coords, end_coords)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_directions_url(start_coords, end_coords)
      conn_geolocation.get("/directions/v2/route") do |req|
      req.params[:from] = start_coords
      req.params[:to] = end_coords
    end
  end
end