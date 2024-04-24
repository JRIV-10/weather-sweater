class RoadTrip
  attr_reader :start_city, :end_city, :travel_time, :weather_at_eta, :id, :time

  def initialize(data)
    require 'pry'; binding.pry
    @start_city = data[:start_city]
    @end_city = data[:end_city]
    @travel_time = total_travel_time(data)
    @time = data[:directions][:route][:time]
    @weather_at_eta = get_end_city_weather(data[:forecast]) unless total_travel_time(data) == "Impossible Route"
    @id = nil
  end

  def arrival_time(time)
    (Time.now + time).strftime("%Y-%m-%d %H:%M")
  end

  def get_end_city_weather(forecast)
    {
      datetime: arrival_time(@time),
      temperature: temp_at_arrival(forecast),
      condition: condition_at_arrival(forecast)
    }
  end

  def total_travel_time(data)
    if data[:directions][:route][:routeError]
      "Impossible Route"
    else
      data[:directions][:route][:formattedTime]
    end
  end

  def temp_at_arrival(forecast)
    data = forecast[:forecast][:forecastday].find { |day| day[:date] == arrival_time(@time)[0..9] }
  
    temp = 0.0
    if data && data[:hour]
      data[:hour].each do |hour|
        if hour[:time][0..12] == arrival_time(@time)[0..12]
          temp = hour[:temp_f]
        end
      end
    end

    temp
  end

  def condition_at_arrival(forecast)
    data = forecast[:forecast][:forecastday].flat_map { |day| day[:hour] }.find { |hour| hour[:time][0..12] == arrival_time(@time)[0..12] }
    data[:condition][:text] if data
  end
end