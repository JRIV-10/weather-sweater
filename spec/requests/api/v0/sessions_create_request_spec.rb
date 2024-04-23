require "rails_helper"

RSpec.describe "Login", type: :request do
  describe "As a User" do

    before do
      @user = User.create!({email: "tiredstudent@turing.com", password: "password123", password_confirmation: "password123", api_key: "t1h2i3s4_i5s6_l7e8g9i10t11"})
      @headers = {"CONTENT_TYPE" => "application/json"}
      @body = {
      email: "tiredstudent@turing.com",
      password: "password123"
    }
    @wrong_email = {
      email: "student@turing.com",
      password: "password123"
    }

    @wrong_password = {
      email: "tiredstudent@turing.com",
      password: "password1233333"
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
      expect(formatted_data[:attributes]).not_to have_key(:password)
      expect(formatted_data[:attributes]).not_to have_key(:password_confirmation)
    end

    describe "sad path" do 
      it 'will return the correct error message if the email is incorrect' do
        post "/api/v0/sessions", headers: @headers, params: JSON.generate(@wrong_email_email)
  
        expect(response).not_to be_successful
        expect(response.status).to eq(401)
        
        result = JSON.parse(response.body, symbolize_names: true)
  
        expect(result).to have_key(:errors)
        expect(result[:errors]).to be_a(Hash)
        expect(result[:errors]).to have_key(:message)
        expect(result[:errors][:message]).to eq("Error: Email/Password incorrect")
      end
  
      it "returns the correct error message if the password is incorrect" do
        post "/api/v0/sessions", headers: @headers, params: JSON.generate(@wrong_password)
  
        expect(response).not_to be_successful
        expect(response.status).to eq(401)
  
        result = JSON.parse(response.body, symbolize_names: true)
  
        expect(result).to have_key(:errors)
        expect(result[:errors]).to be_a(Hash)
        expect(result[:errors]).to have_key(:message)
        expect(result[:errors][:message]).to eq("Error: Email/Password incorrect")
      end 
    end
  end 
end