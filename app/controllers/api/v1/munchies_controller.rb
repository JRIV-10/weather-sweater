class Api::V1::MunchiesController < ApplicationController
  def index 
    service = YelpFacade.find_places(yelp_params)
    response = format_response(service)
    render json: response, status: :ok
  end

  private 

  def yelp_params
    params.permit(:destination, :food)
  end

  def format_response(service)
    {
      data: {
        id: nil,
        type: 'munchie',
        attributes: {
          destination_city: service[:destination_city],
          forecast: service[:forecast],
          restaurant: {
            name: service[:restaurant].name,
            address: service[:restaurant].address,
            rating: service[:restaurant].rating,
            reviews: service[:restaurant].reviews
          }
        }
      }
    }
  end
end