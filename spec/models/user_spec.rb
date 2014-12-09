require 'spec_helper'

RSpec.describe User, :type => :model do

  before do 
    @user1 = User.create!( :fb_uid => '111', :fb_token => "aaa")
    @user2 = User.create!( :fb_uid => '222', :fb_token => "bbb")
    @user3 = User.create!( :mobile_id => '123')
    @auth_hash = {
      'fb_uid' => '333',
      'email' => 'aaa@gmail.com',
      'name' => 'fung',
      'image' => 'fung.png',
      'fb_token' => 'abcdefg',
      'mobile_id' => '1234567'
    }
  end

  it "should initialize relationship from db" do    
    fb_graph = double("graph")
    expect(Koala::Facebook::API).to receive(:new).with(@user2.fb_token).and_return(fb_graph)
    expect(fb_graph).to receive(:get_connections).and_return( [{ 'id' => @user1.fb_uid }] )
  
    # execute
    @user2.initialize_relationship_from_fb

    # verify
    expect(Friendship.count).to eq(1)
    f = Friendship.last
    expect(f.friend).to eq(@user1)
    expect(f.user).to eq(@user2)
  end

  it "should find_or_create_from_auth_hash" do
    user = User.find_or_create_from_auth_hash(@auth_hash)
    expect(user.name).to eq('fung')
    expect(user.fb_expires_at).to eq(nil)

    user = User.where(:name => 'fung').first
    expect(user.mobile_id).to eq('1234567')
  end

  it "should modified mobile id" do
    user = User.modified_mobile_id( { :mobile_id => '123' } )
    expect(user.mobile_id).to_not eq('123')
  end
end





