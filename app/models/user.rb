class User < ActiveRecord::Base

  has_many :recommends
  has_many :restaurants, :through => :recommends

  has_many :friendships
  has_many :friends, :through => :friendships

  def initialize_relationship_from_fb
    @graph = Koala::Facebook::API.new(self.fb_token)
    friends_id = @graph.get_connections("me", "friends").map { |x| x['id'] }
    self.friendships.destroy_all
    friends_id.each do |friend_id|
      user = User.where(:fb_uid => friend_id).first
      friendship = self.friendships.new
      friendship.friend = user
      friendship.save if friendship.friend
    end
    # add self as friend
    friendship = self.friendships.new
    friendship.friend = self
    friendship.save
  end

  def recommend(restaurant, params)
    recommend = self.recommends.where(:restaurant_id => restaurant.id).first_or_initialize
    recommend.restaurant = restaurant
    recommend.content = params[:content]
    recommend.save
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(:fb_uid => auth_hash[:uid]).first_or_initialize
    user.name = auth_hash[:info][:name]
    user.email = auth_hash[:info][:email]
    user.image = auth_hash[:info][:image]
    user.fb_token = auth_hash[:credentials][:token]
    user.fb_expires_at = Time.at(auth_hash[:credentials][:expires_at])
    user.save!
    user
  end
end
