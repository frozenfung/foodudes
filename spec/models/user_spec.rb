require 'spec_helper'

RSpec.describe User, :type => :model do

  before do 
    @user1 = User.create!( :fb_uid => '111', :fb_token => "aaa")
    @user2 = User.create!( :fb_uid => '222', :fb_token => "bbb")
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

end