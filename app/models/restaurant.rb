class Restaurant < ActiveRecord::Base

  has_many :recommends
  has_many :users, :through => :recommends

  def self.random_pick
    if Rails.env.development?
      order("RAND()").first
    else
      order("random()").first
    end
  end

  def self.find_by_name_and_location(name, lat, lng)
    name_and_location_scope(name, lat, lng).first
  end

  def self.find_or_create_from_form(name, lat, lng, options={})
    restaurant = name_and_location_scope(name, lat, lng).first_or_initialize
    restaurant.phone_number = options[:phone_number]
    restaurant.address = options[:address]
    restaurant.save!
    restaurant
  end

  protected

  def self.name_and_location_scope(name, lat, lng)
    where(:name => name).where(:lat => lat).where(:lng => lng)
  end

end
