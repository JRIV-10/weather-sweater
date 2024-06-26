class RoadTrip
  attr_reader :origin, :destination, :travel_time, :weather_at_eta, :id, :time

  def initialize(data)
    @origin = data[:origin]
    @destination = data[:destination]
    @travel_time = total_travel_time(data)
    @time = data[:directions][:route][:time]
    @weather_at_eta = get_destination_weather(data[:forecast]) unless total_travel_time(data) == "Impossible Route"
    @id = nil
  end

  def arrival_time(time)
    (Time.now + time).strftime("%Y-%m-%d %H:%M")
  end

  def get_destination_weather(forecast)
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