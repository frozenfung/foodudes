class ApiV1::UsersController < ApiController
  def login
    @user = User.find_or_create_from_mobile(params[:fb_token])
    
    if @user
      @user.initialize_relationship_from_fb
      render json: @user.as_json(only:[:id, :name, :email, :image, :mobile_id])
    else
      render json: { :message => "you facebook token is wrong"}, :status => 401
    end      
  end

  def signout
    @user = User.modify_mobile_id(params)
    if @user
      render json: @user.as_json(only:[:name])
    else
      render json: { :message => "sign out failed"}, :status => 401
    end
  end
end
