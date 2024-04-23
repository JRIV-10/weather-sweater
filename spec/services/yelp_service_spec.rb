require "rails_helper"

RSpec.describe "YelpService" do
  describe "As a User" do
    describe ".conn" do 
      it "returns a Faraday connection object" do
        conn = YelpService.conn

        expect(conn).to be_a(Faraday::Connection)
        expect(conn.headers).to include('Authorization' => "Bearer #{Rails.application.credentials.yelp_api_key[:key]}", 'accept' => 'application/json')
      end
    end 

    describe ".get_url(url)" do 
      it "returns parsed JSON data from the API" do 
        json_response = File.read("spec/fixtures/yelp_itialin.json")
        stub_request(:get, "https://api.yelp.com/v3/businesses/search?location=Denver,%20CO&sort_by=best_match&term=food=italian").
          with(
            headers: {
              'Authorization'=>"Bearer #{Rails.application.credentials.yelp_api_key[:key]}"
            }).
          to_return(status: 200, body: json_response)

        data = YelpService.get_url("/v3/businesses/search?location=Denver,%20CO&sort_by=best_match&term=food=italian")

        expect(data).to be_a(Hash)
        expect(data).to include(:businesses)
        expect(data[:businesses]).to be_an(Array)
        expect(data[:businesses].first).to include(:id, :name, :location, :rating, :review_count)
      end
    end

    describe ".search(data)" do
      it "returns parsed JSON data for business search" do
        json_response = File.read("spec/fixtures/yelp_itialin.json")
        stub_request(:get, "https://api.yelp.com/v3/businesses/search?limit=1&location=Denver,%20CO&sort_by=best_match&term=food=italian").
          with(
            headers: {
              'Authorization'=>"Bearer #{Rails.application.credentials.yelp_api_key[:key]}"
            }).
          to_return(status: 200, body: json_response)

        data = YelpService.search({ destination: "Denver, CO", food: "italian" })

        expect(data).to be_a(Hash)
        expect(data).to include(:businesses)
        expect(data[:businesses]).to be_an(Array)
        expect(data[:businesses].first).to include(:id, :name, :location, :rating, :review_count)
      end
    end
  end 
end