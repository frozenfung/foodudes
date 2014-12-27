class Recommend < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant

  # for image upload
  has_attached_file :cuisine, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "missing.png"
  validates_attachment_content_type :cuisine, :content_type => /\Aimage\/.*\Z/
  
  def self.create_recommend(user, restaurant, options={})
    recommend = Recommend.new
    recommend.user = user
    recommend.restaurant = restaurant
    recommend.cuisine = options[:cuisine]
    recommend.content = options[:content]
    recommend.save!
  end
end