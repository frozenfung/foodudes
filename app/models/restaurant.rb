class Restaurant < ActiveRecord::Base
  has_many :recommends
  has_many :users, :through => :recommends

  def self.find_or_create_from_form(params)
    restaurant = where(:lat => params[:lat]).where(:lng => params[:lng]).where(:name => params[:name]).first_or_initialize
    restaurant.name = params[:name]
    restaurant.phone_number = (params[:phone_number].length > 1) ? params[:phone_number] : '抱歉！目前沒有資料'
    restaurant.address = (params[:address].length > 1) ? params[:address] : '抱歉！目前沒有資料'
    restaurant.lng = params[:lng]
    restaurant.lat = params[:lat]
    restaurant.save!
    restaurant
  end
end
