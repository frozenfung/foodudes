require 'spec_helper'
require 'restaurant'


RSpec.describe Restaurant, :type => :model do

  let(:params){ 
    {:name => 'test',
     # name: 'test' 
     :address => 'test', 
     :lng => 0.1,
     :lat => 0.1
    }
  }

  it "should find or create a restaurant" do
    Restaurant.find_or_create_from_form(params)
    # expect(param).to eq('test')
    expect(Restaurant.where(:name => 'test').first.address).to eq('test')
  end
end