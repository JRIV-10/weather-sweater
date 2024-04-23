class YelpService
  def self.conn 
    Faraday.new(url: "https://api.yelp.com") do |faraday|
      faraday.headers['Authorization'] = "Bearer #{Rails.application.credentials.yelp_api_key[:key]}"
      faraday.headers['accept'] = 'application/json'
    end
  end

  def self.get_url(url)
    response = conn.get(url)

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(data)
    get_url("/v3/businesses/search?location=#{data[:destination]}&term=food%3D#{data[:food]}&sort_by=best_match&limit=20")
  end
end