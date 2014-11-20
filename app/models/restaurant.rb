class Restaurant < ActiveRecord::Base
  has_many :user_restaurants
  has_many :users, :through => :user_restaurants

  def self.find_or_create_from_form(params)
    restaurant = where(:address => params[:address]).where(:name => params[:name]).first_or_initialize
    restaurant.name = params[:name]
    restaurant.address = params[:address]
    restaurant.lng = params[:lng]
    restaurant.lat = params[:lat]
    restaurant.save!
    restaurant
  end
end
