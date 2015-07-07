class MapsController < ApplicationController
  def index
    if current_user
      # Pass varible to javascript
      gon.map_infos = build_map_infos(current_user)

      # Initialize Recommends and Restaurants to form
      @recommend = current_user.recommends.new
      @restaurant = Restaurant.new
    else
      gon.map_infos = []
    end
  end

  protected

  def build_map_infos(user)
    # Find marker datas from DB
    map_infos = []
    user.friends.each do |friend|
      friend.restaurants.each do |restaurant|
        map_infos << transform_data_structure(restaurant, friend)
      end
    end
    user.restaurants.each do |restaurant|
      map_infos << transform_data_structure(restaurant, user)
    end
    # remove same restaurant
    map_infos.uniq{ |i| i[0]}
  end

  def transform_data_structure(restaurant, friend)
    map_info = []
    map_info << restaurant.name
    map_info << restaurant.phone_number
    map_info << restaurant.address
    map_info << restaurant.lat
    map_info << restaurant.lng
    map_info << friend.image
    map_info
  end
end
