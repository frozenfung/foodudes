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
      @map_infos = @map_infos.uniq{ |i| i['name'] && i['address']}

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
end
