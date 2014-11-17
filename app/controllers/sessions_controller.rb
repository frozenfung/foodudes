class SessionsController < ApplicationController
  def create
    user = User.find_or_create_from_auth_hash(auth_hash)
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
