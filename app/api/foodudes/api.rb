module Foodudes
  class API < Grape::API
    version 'v1', using: :path, vendor: 'foodudes'
    format :json
    prefix :grape_api

    helpers do
      def mobile_user
        User.where(:mobile_id => params[:mobile_id]).first
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless mobile_user
      end
    end

    resource :users do 
      desc "mobile user login."
      params do
        requires :fb_token, type: String, desc: "user's fb token"
      end
      post :login do
        user = User.find_or_create_from_mobile(params[:fb_token])
        user.initialize_relationship_from_fb
        {
          :user => user.as_json(:only => [:id, :name, :email, :image, :mobile_id]),
          :recommend_count => user.restaurants.count
        }
      end

      desc "mobile user signout."
      params do
        requires :mobile_id, type: String, desc: "user's mobile id"
      end
      delete :signout do
        authenticate!           
        user = User.modify_mobile_id(params)
        user.as_json(only:[:name])
      end
    end

    resource :maps do
      desc "organize map info"
      params do
        requires :mobile_id, type: String
      end
      get do
        authenticate!
        map_infos = []
        user_infos = []
        friends = mobile_user.friends
        friends << mobile_user
        friends.each do |friend|
          friend.restaurants.each do |restaurant|
            map_info = {
              'id' => restaurant.id,
              'name' => restaurant.name,
              'phone_number' => restaurant.phone_number,
              'address' => restaurant.address,
              'marker_lng' => restaurant.lng,
              'marker_lat' => restaurant.lat,
              'user' => []
            }
            restaurant.users.each do |user|
              recommend = Recommend.where(:user_id => user.id).where(:restaurant_id => restaurant.id).first
              user_info = {
                'id' => user.id,
                'name' => user.name,
                'image' => user.image,
                'content' => recommend.content,
                'cuisine' => recommend.cuisine.url(:medium)
              }
              map_info['user'] << user_info
            end
            map_infos << map_info           
          end
          unless friend == mobile_user
            user_info = {
              'id' => friend.id,
              'name' => friend.name,
              'email' => friend.email,
              'image' => friend.image,
              'recommend_count' => friend.restaurants.count
            }
            user_infos << user_info
          end
        end
        recommend_infos = {
          'restaurants' => map_infos,
          'users' => user_infos
        }
      end
    end 

    resource :restaurants do
      desc "recommend restaurant"
      post :recommend do
        authenticate!
        restaurant = Restaurant.find_or_create_from_form(params[:name], params[:lat], params[:lng], 
                      :phone_number => params[:phone_number], :address => params[:address])
        Recommend.create_recommend(mobile_user, restaurant, params)
        { :status => 'Recommend Success!' }
      end

      get :random do
        restaurant = Restaurant.order("RAND()").first
        {
          name: restaurant.name,
          address: restaurant.address,
          phone_number: restaurant.phone_number
        }
      end
    end
  end
end

module Paperclip
  class HashieMashUploadedFileAdapter < AbstractAdapter
    attr_accessor :original_filename # use this accessor if you have paperclip version < 3.3.0

    def initialize(target)
      @tempfile, @content_type, @size = target.tempfile, target.type, target.tempfile.size
      self.original_filename = target.filename
    end

  end
end

Paperclip.io_adapters.register Paperclip::HashieMashUploadedFileAdapter do |target|
  target.is_a? Hashie::Mash
end
