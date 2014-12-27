class RestaurantsController < ApplicationController
  
  # skip_before_filter :verify_authenticity_token, :only => [:create]

  def index    
    restaurant = Restaurant.find_by_name_and_location(params[:name], params[:lat], params[:lng])

    if restaurant
      @recommends = restaurant.recommends.order('created_at DESC')
      @friends_count = restaurant.recommends.count
    else
      @recommends = []
      @friends_count = 0
    end
    respond_to do |format|
      format.js
    end
  end

  def create
    @restaurant = Restaurant.find_or_create_from_form(params[:restaurant][:name], params[:restaurant][:lat], params[:restaurant][:lng], 
                                                       :phone_number => params[:restaurant][:phone_number], :address => params[:restaurant][:address])
    Recommend.create_recommend(current_user, @restaurant, :cuisine => params[:recommend][:cuisine], :content => params[:recommend][:content])
    respond_to do |format|
      format.js
    end
  end

end
