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

  def self.get_directions(start_coords_coords, end_coords)
    response = get_directions_url(start_coords, end_coords)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_directions_url(origin_coords, dest_coords)
    conn.get("/directions/v2/route") do |req|
      req.params[:from] = origin_coords
      req.params[:to] = dest_coords
      req.params[:key] = Rails.application.credentials.geolocation_api_key
    end
  end
end