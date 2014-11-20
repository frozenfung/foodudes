class MapsController < ApplicationController
  def index
    if current_user
      # Find marker datas from DB 
      @map_infos = []
      restaurant_name = []
      friends = current_user.friends
      friends.each do |friend|
        user_restaurants = friend.user_restaurants
        user_restaurants.each do |user_restaurant|
          restaurant = user_restaurant.restaurant
          map_info = {}
          map_info['marker_lng'] = restaurant.lng
          map_info['marker_lat'] = restaurant.lat
          map_info['friend_icon'] = friend.image
          map_info['friend_name'] = friend.name
          # map_info[info_window_infos] = []
          # if restaurant_name.include?(restaurant.name)
          #   map_info[infowindow_] = 
          #   map_info[infowindow]
          #   map_info[infowindow]
          #   map_info[infowindow]
          #   map_info[infowindow]
          #   map_info[infowindow]
          # end
          @map_infos << map_info
          restaurant_name << restaurant.name
        end
      end
      gon.map_infos = @map_infos

      # Initialize User_restaurant to form
      @user_restaurant = current_user.user_restaurants.new
      @restaurant = Restaurant.new
    end
  end

  protected
end
