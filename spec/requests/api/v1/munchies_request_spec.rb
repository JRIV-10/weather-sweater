require "rails_helper"

RSpec.describe "Yelp API Request", type: :request do
  describe "As a User" do
    before do
      json_response_1 = File.read("spec/fixtures/denver_coords.json")
      json_response_2 = File.read("spec/fixtures/denver_forecast.json")
      json_response_3 = File.read("spec/fixtures/yelp_itialin.json")
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

      stub_request(:get, "https://api.yelp.com/v3/businesses/search?limit=1&location=Denver,%20CO&sort_by=best_match&term=food=italain").
        with(
          headers: {
            'Authorization'=>"Bearer #{Rails.application.credentials.yelp_api_key[:key]}"
          }).
        to_return(status: 200, body: json_response_3)

        params = {"destination": "Denver, CO", "food": "italain"}
        headers = {"Content_Type": "application/json", "Accept": "application/json"}
        get "/api/v1/munchies", headers: headers, params: params
    end

    it "returns a resturant based off the params" do
      expect(response).to have_http_status(200)

        data = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(data[:type]).to eq("munchie")
        expect(data[:id]).to eq(nil)
        expect(data[:attributes][:destination_city]).to eq("Denver, CO")
        expect(data[:attributes][:forecast][:summary]).to eq("Partly cloudy")
        expect(data[:attributes][:forecast][:temperature]).to eq(48.2)
        expect(data[:attributes][:restaurant][:name]).to eq("Vinny and Marie’s Italian Street Food")
        expect(data[:attributes][:restaurant][:address]).to eq("1477 Monroe St, Denver, 80206, US")
        expect(data[:attributes][:restaurant][:rating]).to eq(5)
        expect(data[:attributes][:restaurant][:reviews]).to eq(17)
    end
  end 
end