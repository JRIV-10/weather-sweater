require "rails_helper"

RSpec.describe "Login", type: :request do
  describe "As a User" do

    before do
      @user = User.create!({email: "tiredstudent@turing.com", password: "password123", password_confirmation: "password123", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11"})
      @headers = {"CONTENT_TYPE" => "application/json"}
      @body = {
      email: "tiredstudent@turing.com",
      password: "password123",
    }
    end

    it "returns user data and api key when correct" do
      post "/api/v0/sessions", headers: @headers, params: JSON.generate(@body)
      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)
      expect(data[:data]).to be_a(Hash)
    
      formatted_data = data[:data]
      expect(formatted_data).to have_key(:type)
      expect(formatted_data[:type]).to eq("users")
      expect(formatted_data).to have_key(:id)
      expect(formatted_data[:id]).to eq(@user.id)
      expect(formatted_data).to have_key(:attributes)
      expect(formatted_data[:attributes]).to be_a(Hash)
      expect(formatted_data[:attributes][:email]).to eq("tiredstudent@turing.com")
      expect(formatted_data[:attributes][:api_key]).to eq(@user.api_key)
    end

    describe "sad path" do 
      
    end
  end 
end