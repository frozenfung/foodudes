class SessionsController < ApplicationController
  def create
    auth_hash_modified = {
      'fb_uid' => auth_hash[:uid],
      'name' => auth_hash[:info][:name],
      'email' => auth_hash[:info][:email],
      'image' => auth_hash[:info][:image],
      'fb_token' => auth_hash[:credentials][:token],
      'fb_expires_at' => Time.at(auth_hash[:credentials][:expires_at])
    } 

    user = User.find_or_create_from_auth_hash(auth_hash_modified)
    session[:user_id] = user.id
    current_user.initialize_relationship_from_fb
    
    redirect_to root_path
  end

  def failure

  end

  def destroy
    reset_session

    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end  
end
