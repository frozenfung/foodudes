class ApiController < ActionController::Base
  
  helper_method :mobile_user

  def mobile_user(mobile_id)
    mobile_user = User.where(:mobile_id => mobile_id).first
  end
end