class BookSearchSerializer
  include JSONAPI::Serializer
  attributes :destination, :forecast
  require 'pry'; binding.pry
end 