require "rails_helper"

RSpec.describe Yelp do
  describe "#initialize" do
    it "sets instance variables correctly" do
      data = {
        name: "Test Restaurant",
        location: {
          address1: "123 Main St",
          city: "Denver",
          zip_code: "80202",
          country: "US"
        },
        rating: 4.5,
        review_count: 100
      }

      yelp = Yelp.new(data)

      expect(yelp.name).to eq("Test Restaurant")
      expect(yelp.address).to eq("123 Main St, Denver, 80202, US")
      expect(yelp.rating).to eq(4.5)
      expect(yelp.reviews).to eq(100)
    end
  end

  describe "#format_address" do
    it "formats address correctly" do
      data = {
        name: "Test Restaurant",
        location: {
          address1: "123 Main St",
          city: "Denver",
          zip_code: "80202",
          country: "US"
        },
        rating: 4.5,
        review_count: 100
      }
      yelp = Yelp.new(data)

      location = {
        address1: "123 Main St",
        city: "Denver",
        zip_code: "80202",
        country: "US"
      }

      formatted_address = yelp.format_address(location)

      expect(formatted_address).to eq("123 Main St, Denver, 80202, US")
    end
  end
end