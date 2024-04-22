require "rails_helper"

RSpec.describe Forecast do
  it "creates Forecast object from parsed JSON data" do
    json = File.read("spec/fixtures/forecast.json")
    data = JSON.parse(json, symbolize_names: true)

    forecast = Forecast.new(data)
    expect(forecast).to be_a(Forecast)

    expect(forecast.current_weather).to be_a(Hash)
    expect(forecast.current_weather[:last_updated]).to eq("2024-04-22 18:00")
    expect(forecast.current_weather[:temperature]).to eq(62.1)
    expect(forecast.current_weather[:feels_like]).to eq(62.1)
    expect(forecast.current_weather[:humidity]).to eq(28)
    expect(forecast.current_weather[:uvi]).to eq(5.0)
    expect(forecast.current_weather[:visibility]).to eq(9.0)
    expect(forecast.current_weather[:condition]).to eq("Partly cloudy")
    expect(forecast.current_weather[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/116.png")

    expect(forecast.daily_weather.size).to eq(5)
    expect(forecast.daily_weather).to be_an(Array)
    expect(forecast.daily_weather[2][:date]).to eq("2024-04-24")
    expect(forecast.daily_weather[2][:sunset]).to eq("08:24 PM")
    expect(forecast.daily_weather[2][:sunrise]).to eq("06:48 AM")
    expect(forecast.daily_weather[2][:max_temp]).to eq(51.3)
    expect(forecast.daily_weather[2][:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/176.png")
    expect(forecast.daily_weather[2][:min_temp]).to eq(38.2)
    expect(forecast.daily_weather[2][:condition]).to eq("Patchy rain nearby")

    expect(forecast.hourly_weather.size).to eq(24)
    expect(forecast.hourly_weather).to be_an(Array)
    expect(forecast.hourly_weather[2][:temperature]).to eq(37.6)
    expect(forecast.hourly_weather[2][:time]).to eq("02:00")
    expect(forecast.hourly_weather[2][:icon]).to eq("//cdn.weatherapi.com/weather/64x64/night/113.png")
    expect(forecast.hourly_weather[2][:condition]).to eq("Clear ")
  end
end