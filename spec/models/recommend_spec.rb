require 'spec_helper'
RSpec.describe Recommend, :type => :model do
  before do
    @user = User.create!( :name => 'fung' )
    @restaurant = Restaurant.create!( :name => '阿妹麵店' )
  end
  let(:params){
    { :content => '推薦肉羹湯\n乾意麵搭配燙青菜\n讚拉' }
  }
  it "should build a new recommend" do
    expect(Recommend.count).to eq(0)
    Recommend.new_recommend(@user, @restaurant, params)
    expect(Recommend.last.user.name).to eq('fung')
    expect(Recommend.last.restaurant.name).to eq('阿妹麵店')
    expect(Recommend.last.content).to eq('推薦肉羹湯\n乾意麵搭配燙青菜\n讚拉')
  end
end