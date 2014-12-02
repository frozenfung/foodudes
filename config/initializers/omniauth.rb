Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FB_KEY'], ENV['SECRET'],
             :scope => 'email, user_friends', :display => 'popup'
end