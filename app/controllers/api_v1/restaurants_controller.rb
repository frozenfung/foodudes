class ApiV1::RestaurantsController < ApiController
  def recommend
    mobile_user = mobile_user(params[:mobile_id])
    if mobile_user
      id = params[:id]
      content = params[:content]
      restaurant = Restaurant.where(:id => id).first
      recommend = mobile_user.recommends.new
      recommend.restaurant = restaurant
      recommend.content = content
      recommend.save!

      render :text => 'OK'
    end
  end
end
