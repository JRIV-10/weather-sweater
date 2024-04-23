require "rails_helper"

RSpec.describe "YelpFacade" do
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
  end

  it "self.find_places(params)" do
    params = {"destination": "Denver, CO", "food": "italain"}
    place = YelpFacade.find_places(params)

    expect(place).to be_a(Hash)
    expect(place).to have_key(:destination_city)
    expect(place[:destination_city]).to eq("Denver, CO")
    expect(place).to have_key(:forecast)
    expect(place[:forecast][:summary]).to eq("Partly cloudy")
    expect(place[:forecast][:temperature]).to eq(48.2)
    expect(place).to have_key(:restaurant)
    expect(place[:restaurant].name).to eq("Vinny and Marie’s Italian Street Food")
    expect(place[:restaurant].address).to eq("1477 Monroe St, Denver, 80206, US")
    expect(place[:restaurant].rating).to eq(5)
    expect(place[:restaurant].reviews).to eq(17)
  end

  it "self.one_restaurant(place)" do
    params = {"destination": "Denver, CO", "food": "italain"}
    data = YelpService.search(params)
    restaurant_data = YelpFacade.extract_restaurant_data(data)

    restaurant = YelpFacade.one_restaurant(restaurant_data)

    expect(restaurant).to be_a(Yelp)
    expect(restaurant.name).to eq("Vinny and Marie’s Italian Street Food")
    expect(restaurant.address).to eq("1477 Monroe St, Denver, 80206, US")
    expect(restaurant.rating).to eq(5)
    expect(restaurant.reviews).to eq(17)
  end 
  it "self.parsed_forecast(location)" do
    location = "Denver, CO"
    forecast = YelpFacade.parsed_forecast(location)

    expect(forecast).to be_a(Hash)
    expect(forecast).to have_key(:summary)
    expect(forecast[:summary]).to eq("Partly cloudy")
    expect(forecast).to have_key(:temperature)
    expect(forecast[:temperature]).to eq(48.2)
  end
end