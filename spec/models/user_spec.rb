require 'spec_helper'

RSpec.describe User, :type => :model do

  before do 
    @user = User.new(:id => 1)
    @restaurant = Restaurant.new(:id => 1)
    @params = {:content => 'QQ'}

    @auth_hash_web = {
      :uid => '123456',
      :info => {
        :name => 'frozen',
        :email => 'frozenfung@gmail.com',
        :image => 'xxx.png'
      },
      :credentials => {
        :token => 'abc',
        :expires_at => Time.now
      }
    }

    @auth_hash_mobile = {

    }

  end

  it "should build a recommend" do
    @user.recommend(@restaurant, @params)
    expect(Recommend.last.content).to eq('QQ')
  end

  it "should find or create from auth_hash_web" do
    User.find_or_create_from_auth_hash(@auth_hash_web)
    expect(User.where(:fb_token => 'abc').first.name).to eq('frozen')
  end

  it "should find or create from auth_hash_mobile" do
    User.find_or_create_from_auth_hash(@auth_hash_web)
    expect(User.where(:fb_token => 'abc').first.name).to eq('frozen')
  end

  # it "should build friendship by fb_uid" do
  #   friends_id.each do |friend_id|
  #     user = User.where(:fb_uid => friend_id).first
  #     User.find(3).friends = user
  #   end
  #   expect(Friendship.count).to eq('2')
  # end


end