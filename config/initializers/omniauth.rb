Rails.application.config.middleware.use OmniAuth::Builder do

  # fb_config = YAML.load( File.read("#{Rails.root}/config/facebook.yml") )[Rails.env]

  provider :facebook, ENV["FB_APP_ID"], ENV["FB_SECRET"],
             :scope => 'email, user_friends', :display => 'popup'
end
