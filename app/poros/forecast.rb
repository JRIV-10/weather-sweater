class Forecast 
  attr_reader :id, 
              :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(attributes)
    @id = nil 
    @current_weather = format_current(attributes[:current])
    @daily_weather = format_weather(attributes[:forecast][:forecastday])
    @hourly_weather = format_hourly(attributes[:forecast][:forecastday][0][:hour])
  end 

  def format_current(data)
    weather = {}
    weather[:last_updated] = data[:last_updated]
    weather[:temperature] = data[:temp_f]
    weather[:feels_like] = data[:feelslike_f]
    weather[:humidity] = data[:humidity]
    weather[:uvi] = data[:uv]
    weather[:visibility] = data[:vis_miles]
    weather[:condition] = data[:condition][:text]
    weather[:icon] = data[:condition][:icon]
    weather
  end

  def format_weather(data_days)
    daily_weather = []
    data_days.each do |data_day|
      daily = {}
      daily[:date] = data_day[:date]
      daily[:sunrise] = data_day[:astro][:sunrise]
      daily[:sunset] = data_day[:astro][:sunset]
      daily[:max_temp] = data_day[:day][:maxtemp_f]
      daily[:min_temp] = data_day[:day][:mintemp_f]
      daily[:condition] = data_day[:day][:condition][:text]
      daily[:icon] = data_day[:day][:condition][:icon]
      daily_weather << daily
    end
    daily_weather
  end

  def format_hourly(hourly_data)
    hours = []
    hourly_data.each do |hour_data|
      hour = {}
      hour[:time] = Time.parse(hour_data[:time]).to_fs(:time)
      hour[:temperature] = hour_data[:temp_f]
      hour[:condition] = hour_data[:condition][:text]
      hour[:icon] = hour_data[:condition][:icon]
      hours << hour 
    end
    hours
  end
end