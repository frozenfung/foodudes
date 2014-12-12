class ApiV1::MapsController < ApiController
  def index
    mobile_user = mobile_user(params[:mobile_id])
    if mobile_user
      map_infos = []
      user_infos = []
      friends = mobile_user.friends
      friends << mobile_user  
      friends.each do |friend|
        friend.restaurants.each do |restaurant|
          # Save map markers data
          map_info = {}
          map_info['id'] = restaurant.id
          map_info['name'] = restaurant.name
          map_info['phone_number'] = restaurant.phone_number
          map_info['address'] = restaurant.address
          map_info['marker_lng'] = restaurant.lng
          map_info['marker_lat'] = restaurant.lat
          map_info['user'] = []
          restaurant.users.each do |user|
            user_info = {}
            user_info['id'] = user.id
            user_info['name'] = user.name
            user_info['image'] = user.image
            user_info['content'] = Recommend.where(:user_id => user.id).where(:restaurant_id => restaurant.id).first.content
            user_info['content'] = user_info['content'].gsub(/<br>/, '\n')
            map_info['user'] << user_info
          end
          map_infos << map_info
        end
        # Save users data
        user_info = {}
        user_info['id'] = friend.id
        user_info['name'] = friend.name
        user_info['email'] = friend.email
        user_info['image'] = friend.image
        user_info['recommend_count'] = friend.restaurants.count
        user_infos << user_info
      end
      recommend_infos = {}
      recommend_infos['restaurants'] = map_infos
      recommend_infos['users'] = user_infos
      respond_to do |format|
        format.html
        format.json { render json: recommend_infos.as_json() }
      end
    end
  end
end
