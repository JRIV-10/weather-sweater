require "rails_helper"

RSpec.describe "Forecast Service" do
  describe "As a User" do
    describe ".city_coordinates(location)" do 
      it "gets coordinates from location" do
        json_response = File.read("spec/fixtures/cin_coords.json")
        stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
          .with(
            query: {
              key: Rails.application.credentials.geolocation_api_key[:key], 
              location: "cincinatti, oh"
            }
          )
          .to_return(status: 200, body: json_response)
        
        data = ForecastService.city_coordinates("cincinatti, oh")

        expect(data).to be_a(Hash)
        expect(data[:results]).to be_a(Array)

        result = data[:results].first
        expect(result[:locations]).to be_an(Array)

        location = result[:locations].first
        expect(location).to be_a(Hash)
        expect(location[:latLng]).to be_a(Hash)
        expect(location[:latLng]).to include(:lat, :lng)
      end
    end 

    describe ".forecastdata(lat_long)" do 
      it "returns forecast based off of coordinates" do 
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

        data = ForecastService.forecast_data(coords)
        expect(data).to be_a(Hash)
        expect(data[:current]).to include(:last_updated, :temp_f, :condition, :humidity, :feelslike_f, :vis_miles, :uv)
        expect(data[:current][:condition]).to include(:text, :icon)
        expect(data[:current]).to_not include(:temp_c, :is_day, :wind_mph, :pressure_in, :precip_in, :feelslike_c, :gust_mph)
        expect(data[:forecast][:forecastday].size).to eq(5)

        single_day = data[:forecast][:forecastday][0]
        expect(single_day).to include(:date, :day, :astro, :hour)

        expect(single_day[:astro]).to include(:sunrise, :sunset)
        expect(single_day[:astro]).to_not include(:moonrise, :moonset, :moon_phase)

        expect(single_day[:day]).to include(:maxtemp_f, :mintemp_f, :condition)
        expect(single_day[:day][:condition]).to include(:text, :icon)
        expect(single_day[:day]).to_not include(:maxtemp_c, :mintemp_c, :avgtemp_f, :maxwind_mph, :totalprecip_in, :avgvis_miles, :avghumidity, :daily_will_it_rain, :daily_chance_of_snow, :uv)

        expect(single_day[:hour].size).to eq(24)
        expect(single_day[:hour][0]).to include(:time, :temp_f, :condition)
        expect(single_day[:hour][0][:condition]).to include(:text, :icon)
        expect(single_day[:hour][0]).to_not include(:temp_c, :wind_mph, :wind_dir, :pressure_in, :precip_in, :humidity, :feelslike_f, :windchill_f, :heatindex_f, :vis_miles, :uv, :air_quality)
      end
    end
  end 
end