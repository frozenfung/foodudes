class MapsController < ApplicationController 
  def index
    if current_user
      # Find marker datas from DB 
      @map_infos = []
      friends = current_user.friends
      friends.each do |friend|
        friend.restaurants.each do |restaurant|
          @map_infos << transform_dataStructure(restaurant, friend)
        end
      end
      current_user.restaurants.each do |restaurant|
        @map_infos << transform_dataStructure(restaurant, current_user)
      end
      # remove same restaurant
      @map_infos = @map_infos.uniq{ |i| i['name']}

      # Pass varible to javascript
      gon.map_infos = @map_infos

      # Initialize Recommends and Restaurants to form
      @recommend = current_user.recommends.new
      @restaurant = Restaurant.new
    else
      gon.map_infos = []
    end
  end

  protected

  def transform_dataStructure(restaurant, friend)
    map_info = {}
    map_info['name'] = restaurant.name
    map_info['phone_number'] = restaurant.phone_number
    map_info['address'] = restaurant.address
    map_info['marker_lng'] = restaurant.lng
    map_info['marker_lat'] = restaurant.lat
    map_info['friend_icon'] = friend.image
    map_info
  end  
end
