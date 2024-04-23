require "rails_helper"

RSpec.describe "User Registration", type: :request do
  describe "As a User" do
    before do 
      @headers = {"CONTENT_TYPE" => "application/json"}
      @body = {
      email: "tiredstudent@turing.com",
      password: "password123",
      password_confirmation: "password123"
    }
    end

    it "can register a new user" do
      post "/api/v0/users", headers: @headers, params: JSON.generate(@body)
      
      expect(response).to be_successful
      expect(response.status).to eq(201)

      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to have_key(:data)
      expect(data[:data]).to be_a(Hash)
    
      formatted_data = data[:data]
      expect(formatted_data).to have_key(:type)
      expect(formatted_data[:type]).to eq("users")
      expect(formatted_data).to have_key(:id)
      expect(formatted_data[:id]).to be_a(Integer)
      expect(formatted_data).to have_key(:attributes)
      expect(formatted_data[:attributes]).to be_a(Hash)
      expect(formatted_data[:attributes][:email]).to eq("tiredstudent@turing.com")
      expect(formatted_data[:attributes][:api_key]).to be_a(String)
    end

    describe "sad path" do 
      it "errors with invalid password or email" do 
      post "/api/v0/users", headers: @headers, params: JSON.generate({email: "", password: "password123", password_confirmation: "password123"})
      
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to have_key(:errors)
      expect(data[:errors]).to be_a(Hash)
      expect(data[:errors][:message]).to eq("Validation failed: Email can't be blank")
      end

      it "errors when the passwords are not the same" do 
        post "/api/v0/users", headers: @headers, params: JSON.generate({email: "tiredstudent@turing.com", password: "password12355", password_confirmation: "password123"})
      
        expect(response).to_not be_successful
        expect(response.status).to eq(400)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to have_key(:errors)
        expect(data[:errors]).to be_a(Hash)
        expect(data[:errors][:message]).to eq("Validation failed: Password confirmation doesn't match Password")
      end
    end
  end 
end