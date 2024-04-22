require "rails_helper"

RSpec.describe "Forecast Facade" do
  describe "As a User" do
    describe ".forecast_location(location)" do 
      it "returns location coordinates" do
        json_response = File.read("spec/fixtures/cin_coords.json")

        stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
          .with(
            query: {
              key: Rails.application.credentials.geolocation_api_key[:key], 
              location: "cincinatti, oh"
            }
          )
          .to_return(status: 200, body: json_response)

        coords = ForecastFacade.forecast_location("cincinatti, oh")

        expect(coords).to be_a(Hash)
        expect(coords).to have_key(:lat)
        expect(coords[:lat]).to eq(39.10713)
        expect(coords).to have_key(:lng)
        expect(coords[:lng]).to eq(-84.50413)
      end
    end 

    describe ".weather_forecast(coords)" do 
      it "returns forecast based off coordinates" do 
        json_response = File.read("spec/fixtures/forecast.json")
        coords = {lat: 39.10713, lng: -84.50413}
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
          .to_return(status: 200, body: json_response)

        forecast = ForecastFacade.weather_forecast(coords)

        expect(forecast).to be_a(Forecast)
        expect(forecast.current_weather).to be_a(Hash)
        expect(forecast.daily_weather).to be_a(Array)
        expect(forecast.daily_weather).to all(be_a(Hash))
        expect(forecast.hourly_weather).to be_a(Array)
        expect(forecast.hourly_weather).to all(be_a(Hash))
      end
    end
  end 
end