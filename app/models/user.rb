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
    recommend.content = params[:content].gsub(/\n/, '<br>').squish
    recommend.save
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(:email => auth_hash['email']).first_or_initialize
    user.id = auth_hash['id']
    user.name = auth_hash['name']
    user.image = auth_hash['image']
    user.fb_token = auth_hash['fb_token'] if auth_hash['fb_token']
    user.fb_expires_at = auth_hash['fb_expires_at'] if auth_hash['fb_expires_at']
    user.mobile_id = auth_hash['mobile_id'] if auth_hash['mobile_id']
    user.save!
    user
  end

  def self.modified_mobile_id(params)
    user = where(:mobile_id => params[:mobile_id]).first
    user.mobile_id = SecureRandom.uuid
    user.save!
  end
end









