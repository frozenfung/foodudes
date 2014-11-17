class User < ActiveRecord::Base

  has_many :user_restaurants
  has_many :restaurants, :through => :user_restaurants

  has_many :friendships
  has_many :friends, :through => :friendships

  def initialize_relationship_from_fb
    @graph = Koala::Facebook::API.new(self.fb_token)
    friends_id = @graph.get_connections("me", "friends").map { |x| x['id'] }
    friends_id.each do |friend_id|
      user = User.where(:fb_uid => friend_id).first
      friendship = self.friendships.new
      friendship.friend = user
      friendship.save
    end
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
