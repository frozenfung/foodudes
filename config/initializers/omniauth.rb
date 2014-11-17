Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '472910486181357', 'd2f0fa264e1edcf98278e01b4cdd09f0',
             :scope => 'email, user_friends', :display => 'popup'
end