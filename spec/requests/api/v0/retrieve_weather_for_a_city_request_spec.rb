require 'rails_helper'

RSpec.describe 'Forecast Request', type: :request do
  it 'retrieves forecast data for a given city' do
    json_response_1 = File.read("spec/fixtures/cin_coords.json")
    json_response_2 = File.read("spec/fixtures/forecast.json")
    stub_request(:get, "https://mapquestapi.com/geocoding/v1/address")
      .with(
        query: {
          key: Rails.application.credentials.geolocation_api_key[:key], 
          location: "cincinatti, oh"
        }
      )
      .to_return(status: 200, body: json_response_1)
    
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
      .to_return(status: 200, body: json_response_2)

    params = {"location": "cincinatti, oh"}
    headers = {"Content_Type": "application/json", "Accept": "application/json"}

    get "/api/v0/forecast", headers: headers, params: params

    expect(response).to be_successful

    forecast = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(forecast[:id]).to eq(nil)
    expect(forecast[:type]).to eq('forecast')
    expect(forecast[:attributes]).to have_key(:current_weather)
    expect(forecast[:attributes]).to have_key(:daily_weather)
    expect(forecast[:attributes]).to have_key(:hourly_weather)

    current_weather = forecast[:attributes][:current_weather]
    expect(current_weather).to have_key(:last_updated)
    expect(current_weather).to have_key(:temperature)
    expect(current_weather).to have_key(:feels_like)
    expect(current_weather).to have_key(:uvi)
    expect(current_weather).to have_key(:humidity)
    expect(current_weather).to have_key(:condition)
    expect(current_weather).to have_key(:visibility)
    expect(current_weather).to have_key(:icon)

    daily_weather = forecast[:attributes][:daily_weather]
    expect(daily_weather).to be_a(Array)
    expect(daily_weather).to all(include(:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon))
    
    hourly_weather = forecast[:attributes][:hourly_weather]
    expect(hourly_weather).to be_a(Array)
    expect(hourly_weather).to all(include(:time, :temperature, :condition, :icon))
  end
end