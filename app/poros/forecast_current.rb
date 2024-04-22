class ForecastCurrent < Forecast
  attr_reader :summary,
              :temperature
  def initialize(data)
    @summary = data[:current][:condition][:text]
    @temperature = data[:current][:temp_f]
  end
end