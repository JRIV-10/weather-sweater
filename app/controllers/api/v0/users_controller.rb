class Api::V0::UsersController < ApplicationController
  def create
    user = User.new(new_user_params)
    user.save!
    render json: UserSerializer.serialize(user), status: 201
  end

  private 

  def new_user_params
    params.permit(:email, :password, :password_confirmation)
  end
end