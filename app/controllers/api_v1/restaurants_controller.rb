class ApiV1::RestaurantsController < ApiController
  def recommend
    mobile_user = mobile_user(params[:mobile_id])
    if mobile_user
      restaurant = Restaurant.find_or_create_from_form(params[:name], params[:lat], params[:lng],
                                                       :phone_number => params[:phone_number], :address => params[:address] )
      Recommend.create_recommend(mobile_user, restaurant, params)
      render :text => 'Recommend Success!'
    end
  end

  def random
    restaurant = Restaurant.random_pick

    respond_to do |format|
      format.json { render json: restaurant.to_json(only: [:name, :address, :phone_number]) }
    end
  end
end
