class Api::V0::TripController < ApplicationController
  def create
    user = User.find_by(api_key: params[:api_key])
    if user 
      trip = TripFacade.trip_details(trip_params)
      render json: TripSerializer.new(trip), status: 201
    else
      render json: ErrorSerializer.serialize(ErrorMessage.new("Error: Could not verify API Key", 401)), status: 401
    end
  end

  private 

  def trip_params
    params.require(:trip).permit(:start_city, :end_city)
  end
end