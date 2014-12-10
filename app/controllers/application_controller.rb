class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user  
    current_user = User.find(session[:user_id]) if session[:user_id]
  end

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
