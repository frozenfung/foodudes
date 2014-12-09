class Recommend < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  def self.new_recommend(user, restaurant, content)
    recommend = Recommend.new
    recommend.user = user
    recommend.restaurant = restaurant
    recommend.content = content
    recommend.save!
  end
end
