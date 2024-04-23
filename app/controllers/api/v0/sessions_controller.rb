class Api::V0::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if valid_user?(user)
      render json: UserSerializer.serialize(user), status: 200
    else 
      render 
    end
  end
end