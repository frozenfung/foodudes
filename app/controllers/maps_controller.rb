class MapsController < ApplicationController
  def index
    if current_user
      # Find marker datas from DB 
      @map_infos = []
      restaurant_name = []
      friends = current_user.friends
      friends.each do |friend|
        recommends = friend.recommends
        recommends.each do |recommend|
          restaurant = recommend.restaurant
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
      @recommend = current_user.recommends.new
      @restaurant = Restaurant.new
    else
      gon.nothing = []
    end
  end

  protected
end
