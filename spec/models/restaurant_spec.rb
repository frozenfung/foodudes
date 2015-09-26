require 'spec_helper'
RSpec.describe Restaurant, :type => :model do
  describe "find_or_create_from_form" do
    before do
      @restaurant = Restaurant.create!(
        :name => '阿妹麵店',
        :phone_number => '111111111',
        :address => '台北市中正區羅斯福路1號之1',
        :lng => 1.2,
        :lat => 3.4
      )
    end

    let(:name_1) { "阿妹麵店" }
    let(:name_2) { "威爾貝克咖啡" }
    let(:lng) { 1.2 }
    let(:lat) { 3.4 }

    let(:params_find){
      {
       :phone_number => '123456789',
       :address => '台北市中正區羅斯福路1號'
      }
    }

    let(:params_create){
      {
       :phone_number => '987654321',
       :address => '台北市中正區羅斯福路2號'
      }
    }

    it "should find a restaurant from form" do
      expect(@restaurant.address).to eq('台北市中正區羅斯福路1號之1')
      restaurant = Restaurant.find_or_create_from_form(name_1, lng, lat, params_find)
      restaurant = Restaurant.where(:name => '阿妹麵店').first
      expect(restaurant.address).to eq('台北市中正區羅斯福路1號之1')
    end

    it "should create a restaurant from form" do
      restaurant = Restaurant.where(:name => '威爾貝克咖啡').first
      expect(restaurant).to eq(nil)
      restaurant = Restaurant.find_or_create_from_form(name_2, lng, lat, params_create)
      restaurant = Restaurant.where(:name => '威爾貝克咖啡').first
      expect(restaurant.address).to eq('台北市中正區羅斯福路2號')
    end
  end
end
