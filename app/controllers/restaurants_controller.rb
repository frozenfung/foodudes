class RestaurantsController < ApplicationController
  def index
    @recommend_infos = ''
    @recommend_by_myself = '.recommend'
    restaurant = Restaurant.where(:name => params[:name]).where(:address => params[:address]).first
    restaurant.recommends.each do |recommend|
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
    respond_to do |format|
      format.js
    end
  end

  def create
    restaurant = Restaurant.find_or_create_from_form(restaurant_params)
    current_user.recommend(restaurant, recommend_params)
    redirect_to root_path
  end

  protected

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :lng, :lat)
  end

  def recommend_params
    params.require(:recommend).permit(:content)
  end

end
