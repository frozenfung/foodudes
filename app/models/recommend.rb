class Recommend < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  def self.new_recommend(user, restaurant, params)
    recommend = Recommend.new
    recommend.user = user
    recommend.restaurant = restaurant
    recommend.content = params[:content].gsub(/\n/, '<br>').squish
    recommend.save!
  end
end
