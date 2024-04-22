require 'rails_helper'

RSpec.describe 'Book-Search Request', type: :request do
  before do 
    json_response_1 = File.read("spec/fixtures/denver_coords.json")
    json_response_2 = File.read("spec/fixtures/denver_forecast.json")
    json_response_3 = File.read("spec/fixtures/book_search.json")
    stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
      .with(
        query: {
          key: Rails.application.credentials.geolocation_api_key[:key], 
          location: "Denver, CO"
        }
      )
      .to_return(status: 200, body: json_response_1)
    
    coords = {lat: 39.74001, lng: -104.99202}
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json")
      .with(
        query: {
          key: Rails.application.credentials.weather_api_key[:key],
          q: "#{coords[:lat]},#{coords[:lng]}",
          days: 5,
          aqi: "no", 
          alerts: "no" 
        }
      )
      .to_return(status: 200, body: json_response_2)

      stub_request(:get, "https://openlibrary.org/search.json")
        .with(
          query: {
            q: "Denver, CO"
          }
        )
        .to_return(status: 200, body: json_response_3)

      params = {"location": "Denver, CO", "quantity": "5"}
      headers = {"Content_Type": "application/json", "Accept": "application/json"}
      get "/api/v1/book-search", headers: headers, params: params
  end

  it "returns a successful response" do
   
  end
end

