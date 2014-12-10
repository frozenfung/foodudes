class RestaurantsController < ApplicationController
  
  def index    
    restaurant = Restaurant.where(:name => params[:name]).where(:lat => params[:lat]).where(:lng => params[:lng]).first
    
    @recommends = restaurant.recommends.order('created_at DESC')
    @friends_count = restaurant.recommends.count

    respond_to do |format|
      format.js
    end
  end

  def create
    restaurant = Restaurant.find_or_create_from_form(restaurant_params)
    Recommend.new_recommend(current_user, restaurant, recommend_params)
    @info = []
    @info[0] = restaurant_params['name']
    @info[1] = restaurant_params['phone_number']
    @info[2] = restaurant_params['address']
    @info[3] = restaurant_params['lat']
    @info[4] = restaurant_params['lng']
    @info[5] = current_user.image
    respond_to do |format|
      format.js
    end
  end

  protected

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone_number, :lng, :lat)
  end

  def recommend_params
    params.require(:recommend).permit(:content)
  end

end
