class ForecastService
  def self.city_coordinates(location)
    get_url_geolocation("/geocoding/v1/address", location: location)
  end

  def self.get_url_geolocation(url, params) 
    response = conn_geolocation.get(url, params)
    data = JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn_geolocation
    Faraday.new(url:"https://mapquestapi.com") do |faraday|
      faraday.params['key'] = Rails.application.credentials.geolocation_api_key[:key]
    end
  end

  def self.conn_weather
    Faraday.new(url: "http://api.weatherapi.com") do |faraday|
      faraday.params['key'] = Rails.application.credentials.weather_api_key[:key]
    end
  end

  def self.get_url_forecast(url, params) 
    response = conn_weather.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.forecast_data(lat_long)
    params = {
      q: "#{lat_long[:lat]},#{lat_long[:lng]}",
      days: 5,
      aqi: "no",
      alerts: "no"
    }
    get_url_forecast("/v1/forecast.json", params)
  end
end