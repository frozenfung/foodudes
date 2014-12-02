Rails.application.config.middleware.use OmniAuth::Builder do
  
  fb_config = YAML.load( File.read("#{Rails.root}/config/facebook.yml") )[Rails.env]

  provider :facebook, fb_config["key"], fb_config["secret"],
             :scope => 'email, user_friends', :display => 'popup'
end