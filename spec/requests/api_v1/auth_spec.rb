require 'spec_helper'

RSpec.describe "api/v1/auth", :type => :request do

  describe "log in" do
    let(:params){
      {
        :fb_token => '123'
      }
    }

    let(:auth_hash){
      {
        'id' => '1',
        'first_name' => 'chun-fung',
        'last_name' => 'lee',
        'email' => 'fung@gmail.com'
      }
    }

    it "should login" do
      fb_graph = double("graph")
      allow(Koala::Facebook::API).to receive(:new).with(params[:fb_token]).and_return(fb_graph)
      allow(fb_graph).to receive(:get_object).and_return(auth_hash)
      allow(fb_graph).to receive(:get_connections).and_return([])

      post "/api/v1/auth/log_in", :fb_token => '123'

      expect(response.status).to eq(200)

      user = User.last
      expect(response.body).to eq(
        {
          :user => {
            :id => user.id,
            :name => user.name,
            :email => user.email,
            :image => user.image,
            :mobile_id => user.mobile_id
          },
          :recommend_count => 0
        }.to_json
      )
    end

    it "should login failed" do
      allow(Koala::Facebook::API).to receive(:new).and_raise( Koala::Facebook::AuthenticationError.new(nil,nil, "Wrong!") )

      post "/api/v1/auth/log_in", :fb_token => '123'

      expect(response.status).to eq(401)
      expect(User.count).to eq(0)
    end
  end


  describe "sign out" do
    before do
      @user_signout = User.create!(:name => 'fung', :mobile_id => '456')
    end

    it "should sign out" do
      delete "/api/v1/auth/sign_out", :mobile_id => '456'

      expect(response.status).to eq(200)
      expect(response.body).to eq(
        {:name => @user_signout.name}.to_json
      )
      @user_signout.reload
      expect(@user_signout.mobile_id).to_not eq('456')
    end
  end
end
