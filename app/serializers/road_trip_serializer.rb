class RoadTripSerializer
  include JSONAPI::Serializer
  attributes :id, :origin, :destination, :travel_time, :weather_at_eta
end