class User < ActiveRecord::Base

  has_many :recommends
  has_many :restaurants, :through => :recommends

  has_many :friendships
  has_many :friends, :through => :friendships

  def initialize_relationship_from_fb
    graph = Koala::Facebook::API.new(self.fb_token)
    friend_uids = graph.get_connections("me", "friends").map { |x| x['id'] }
    self.class.transaction do 
      self.friendships.destroy_all
      friend_uids.each do |friend_uid|
        friend = User.where(:fb_uid => friend_uid).first
        if friend 
          friendship = self.friendships.new
          friendship.friend = friend
          friendship.save!
        end
      end
    end
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(:fb_uid => auth_hash['fb_uid']).first_or_initialize
    user.email = auth_hash['email']
    user.name = auth_hash['name']
    user.image = auth_hash['image']
    user.fb_token = auth_hash['fb_token']
    user.fb_expires_at = auth_hash['fb_expires_at'] if auth_hash['fb_expires_at']
    user.mobile_id = auth_hash['mobile_id'] if auth_hash['mobile_id']
    user.save!
    user
  end

  def self.modify_mobile_id(params)
    user = where(:mobile_id => params[:mobile_id]).first
    if user
      user.mobile_id = SecureRandom.uuid
      user.save!
      user
    end
  end
end









