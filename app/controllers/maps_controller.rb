class MapsController < ApplicationController
  def index
    if current_user
      # Find marker datas from DB 
      @map_infos = []
      @user_infos = []
      friends = current_user.friends
      friends.each do |friend|
        friend.restaurants.each do |restaurant|
          # Save map markers data
          map_info = {}
          map_info['name'] = restaurant.name
          map_info['phone_number'] = restaurant.phone_number
          map_info['address'] = restaurant.address
          map_info['marker_lng'] = restaurant.lng
          map_info['marker_lat'] = restaurant.lat
          map_info['user_id'] = []
          # restaurant.users.each do |user|
          #   map_info['user_id'] << user.id
          # end
          @map_infos << map_info
        end
        # Save users data
        # user_info = {}
        # user_info['id'] = friend.id
        # user_info['name'] = friend.name
        # user_info['email'] = friend.email
        # user_info['image'] = friend.image
        # @user_infos << user_info
      end
      # Pass varible to javascript
      gon.map_infos = @map_infos
      # gon.user_infos = @user_infos

      # Initialize Recommends and Restaurants to form
      @recommend = current_user.recommends.new
      @restaurant = Restaurant.new
    else
      gon.map_infos = []
      # gon.user_infos = []
    end
  end

  protected
end
