class RestaurantsController < ApplicationController
  def index
    @recommend_infos = ''
    @recommend_by_myself = '.recommend'
    restaurant = Restaurant.where(:name => params[:name]).where(:address => params[:address]).first
    if restaurant
      restaurant.recommends.order('created_at DESC').each do |recommend|
        if current_user.friends.include?(recommend.user)
          @recommend_by_myself = '.recommend_already' if recommend.user == current_user
          recommend_info = '<li>'
          recommend_info += '<div>'
          recommend_info += '<img src=\"'+ recommend.user.image + '\"/>'
          recommend_info += '<div>' + recommend.user.name + '推薦</div>'
          recommend_info += '</div>'
          recommend_info += '<div>' + recommend.content + '</div>'
          recommend_info += '</li>'
          @recommend_infos += recommend_info
        end
      end
      @friends_count = restaurant.recommends.count
    end
    respond_to do |format|
      format.js
    end
  end

  def create
    restaurant = Restaurant.find_or_create_from_form(restaurant_params)
    current_user.recommend(restaurant, recommend_params)
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

  def find
    
  end


  protected

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone_number, :lng, :lat)
  end

  def recommend_params
    params.require(:recommend).permit(:content)
  end

end
