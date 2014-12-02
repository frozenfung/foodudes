class ApiV1::UsersController < ApiController
  def login
    @graph = Koala::Facebook::API.new(params[:fb_token])
    # @graph = Koala::Facebook::API.new(params[:fb_token])
    auth_hash = @graph.get_object("me")
    auth_hash_modified = {
      'id' => auth_hash['id'],
      'name' => "#{auth_hash['last_name']} #{auth_hash['first_name']}",
      'email' => auth_hash['email'],
      'image' => "http://graph.facebook.com/#{auth_hash['id']}/picture",
      'fb_token' => params[:fb_token],
      'mobile_id' => SecureRandom.uuid
    }
    @user = User.find_or_create_from_auth_hash(auth_hash_modified)
    @user.initialize_relationship_from_fb
    respond_to do |format|
      format.html
      format.json { render json: @user.as_json(only:[:id, :name, :email, :image, :mobile_id]) }
    end
  end

  def signout
    User.modify_mobile_id(params)
    render :text => 'OK'
  end
end
