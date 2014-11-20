class RestaurantsController < ApplicationController
  def index

  end

  def create
    restaurant = Restaurant.find_or_create_from_form(restaurant_params)
    current_user.recommend(restaurant, user_restaurant_params)
    redirect_to root_path
  end

  protected

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :lng, :lat)
  end

  def user_restaurant_params
    params.require(:user_restaurant).permit(:comment, :dish, :notice)
  end

end
