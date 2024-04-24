require "rails_helper"

RSpec.describe "RoadTrip request", type: :request do
  describe "As a User" do

    before do
      @user = User.create!({email: "test@email.com", password: "password", password_confirmation: "password"})
      @api_key = @user.api_key
      @headers = {"CONTENT_TYPE" => "application/json"}
      @body = {start_city: "san diego, ca", end_city: "denver, co", api_key: @api_key}
      @start_coords = "32.71568,-117.16171"
      @end_coords = "39.74001,-104.99202"
      @start_city = "san diego, ca"
      @end_city = "denver, co"

      json_response_1 = File.read("spec/fixtures/sd_coords.json")
      stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
        .with(
          query: {
            key: Rails.application.credentials.geolocation_api_key[:key], 
            location: "san diego, ca"
          }
        )
        .to_return(status: 200, body: json_response_1)
    
        json_response_2 = File.read("spec/fixtures/denver_coords.json")
        stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
          .with(
            query: {
              key: Rails.application.credentials.geolocation_api_key[:key], 
              location: "denver, co"
            }
          )
          .to_return(status: 200, body: json_response_2)
      
      json_response_3 = File.read("spec/fixtures/sd_to_den.json")
      stub_request(:get, "https://mapquestapi.com/directions/v2/route?from%5Blat%5D=32.71568&from%5Blng%5D=-117.16171&key=#{Rails.application.credentials.geolocation_api_key[:key]}&to%5Blat%5D=39.74001&to%5Blng%5D=-104.99202")
        .to_return(status: 200, body: json_response_3)
  
      json_response_4 = File.read("spec/fixtures/denver_forecast.json")
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
        .to_return(status: 200, body: json_response_4)
    end

    it "displays weather from the end city location for time of arrival" do
      post "/api/v0/road_trip", headers: @headers, params: JSON.generate(@body)
      
      expect(response).to be_successful
      expect(response.status).to eq(201)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:data)
      expect(result[:data]).to be_a(Hash)

      data = result[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to eq(nil)
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("road_trip")
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      attributes = data[:attributes]
      
      expect(attributes).to have_key(:start_city)
      expect(attributes[:start_city]).to be_a(String)
      expect(attributes).to have_key(:end_city)
      expect(attributes[:end_city]).to be_a(String)
      expect(attributes).to have_key(:travel_time)
      expect(attributes[:travel_time]).to be_a(String)
      expect(attributes).to have_key(:weather_at_eta)
      expect(attributes[:weather_at_eta]).to be_a(Hash)

      weather = attributes[:weather_at_eta]

      expect(weather).to have_key(:datetime)
      expect(weather[:datetime]).to be_a(String)
      expect(weather).to have_key(:temperature)
      expect(weather[:temperature]).to be_a(Float)
      expect(weather).to have_key(:condition)
      expect(weather[:condition]).to be_a(String)
    end
  end 
end