class Recommend < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  def self.create_recommend(user, restaurant, options={})
    recommend = Recommend.new
    recommend.user = user
    recommend.restaurant = restaurant
    recommend.content = options[:content]
    recommend.save!
  end
end