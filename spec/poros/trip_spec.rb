require 'rails_helper'

RSpec.describe Trip do
  before do
    directions = File.read("spec/fixtures/sd_to_den.json")
    directions = JSON.parse(directions, symbolize_names: true)

    forecast = File.read("spec/fixtures/denver_forecast.json")
    @forecast = JSON.parse(forecast, symbolize_names: true)

    trip_data = { directions: directions, forecast: @forecast, origin: "san diego, ca", destination: "denver, co" }

    @trip = Trip.new(trip_data)

    allow(Time).to receive(:now).and_return(Time.new("2024-04-24 01:54:33.492178 -0700"))
  end

  describe 'initialize' do
    it 'exists' do
      expect(@trip).to be_a(Trip)
    end

    it 'has attributes' do
      expect(@trip.start_city).to eq("san diego, ca")
      expect(@trip.end_city).to eq("denver, co")
      expect(@trip.travel_time).to eq("14:54:21")
      expect(@trip.weather_at_eta).to be_a(Hash)
    end
  end

  describe '#instance methods' do
    describe '#get_end_city_weather(forecast)' do
      it 'creates a hash with the appropriate data' do
        expect(@trip.get_end_city_weather(@forecast)).to eq({ datetime: "2024-04-24 16:48", temperature: 75.3, condition: "Partly Cloudy " })
      end
    end

    describe '#temp_at_arrival(forecast)' do
      it 'returns the temperature at the estimated arrival time' do
        expect(@trip.temp_at_arrival(@forecast)).to eq(75.3)
      end
    end

    describe '#condition_at_arrival(forecast)' do
      it 'returns the text of conditions at the estimated arrival time' do
        expect(@trip.condition_at_arrival(@forecast)).to eq("Partly Cloudy ")
      end
    end
  end
end