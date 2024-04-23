class Yelp 
  attr_reader :name,
              :address,
              :rating,
              :reviews

  def initialize(data)
    @name = data[:name]
    @address = format_address(data[:location])
    @rating = data[:rating]
    @reviews = data[:review_count]
  end

  def format_address(location)
    address_fields = [:address1, :address2, :address3, :city, :zip_code, :country]
    address_fields.map { |field| location[field] }.compact.join(", ")
  end
end