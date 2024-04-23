class Api::V0::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if valid_user?(user)
      render json: UserSerializer.serialize(user), status: 200
    else 
      render json: ErrorSerializer.serialize(ErrorMessage.new("Error: Email/Password incorrect", 401)), status: 401
    end
  end

  private

  def valid_user?(user) 
    user && user.authenticate(params[:password])
  end
end