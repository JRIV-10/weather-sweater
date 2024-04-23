require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of :email}
  it { should validate_presence_of :email}
  it { should validate_uniqueness_of :api_key}
  it { should validate_presence_of :password }

  it "should create an api key for a new user" do 
    user = User.create!({email: "tiredstudent@turing.com", password: "password123", password_confirmation: "password123"})
    expect(user).to be_a(User)
    expect(user.api_key).to_not eq(nil)
  end
end
