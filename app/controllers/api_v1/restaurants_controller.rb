class ApiV1::RestaurantsController < ApiController
  def recommend
    mobile_user = mobile_user(params[:mobile_id])
    if mobile_user
      modified_params = {
        :name => params[:name],
        :phone_number => params[:phone_number],
        :address => params[:address],
        :lat => params[:lat],
        :lng => params[:lng]
      }
      restaurant = Restaurant.find_or_create_from_form(modified_params)
      Recommend.new_recommend(mobile_user, restaurant, params[:content])
      render :text => 'Recommend Success!'
    end
  end
end
