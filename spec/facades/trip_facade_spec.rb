require 'rails_helper'

RSpec.describe TripFacade do
  before(:each) do
    @facade = TripFacade
    @start_city = "san diego, ca"
    @end_city = "denver, co"
    @start_coords = "32.71568,-117.16171"
    @end_coords = "39.74001,-104.99202"

    json_response = File.read("spec/fixtures/sd_coords.json")
    stub_request(:get, "https://mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.geolocation_api_key[:key]}&location=san%20diego,%20ca")
      .to_return(status: 200, body: json_response)
  
    json_response = File.read("spec/fixtures/denver_coords.json")
    stub_request(:get, "https://mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.geolocation_api_key[:key]}&location=denver,%20co")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/sd_to_den.json")
    stub_request(:get, "https://mapquestapi.com/directions/v2/route?from=32.71568,-117.16171&key=#{Rails.application.credentials.geolocation_api_key[:key]}&to=39.74001,-104.99202")
      .to_return(status: 200, body: json_response)

    json_response = File.read("spec/fixtures/denver_forecast.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?key=#{Rails.application.credentials.geolocation_api_key[:key]}&q=#{@end_coords}&days=5&aqi=no&alerts=no")
      .to_return(status: 200, body: json_response)
  end

  describe '.start_directions(start_coords, end_coords)' do
    it 'returns directions info' do
      data = @facade.start_directions(@start_coords, @end_coords)

      expect(data).to have_key(:route)
      expect(data[:route]).to be_a(Hash)
      
      route = data[:route]

      expect(route).to have_key(:formattedTime)
      expect(route[:formattedTime]).to be_a(String)
      expect(route).to have_key(:time)
      expect(route[:time]).to be_a(Integer)
      expect(route).not_to have_key(:routeError) 
    end
  end

  describe '.start_trip' do
    it 'creates a road trip object from the given data' do
      expect(@facade.start_trip(@origin_coords, @dest_coords, @origin, @destination)).to be_a(Trip)
    end
  end

  describe 'trip_details(params)' do
    it 'gets the road trip object from the params passed in' do
      params = {start_city: @start_city, end_city: @end_city}

      expect(@facade.trip_details(params)).to be_a(Trip)
    end
  end
end