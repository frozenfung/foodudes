Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '795450763826632', '04ee62e240c66a00236d11539e5bfe65',
             :scope => 'email, user_friends', :display => 'popup'
  # provider :facebook, '472910486181357', 'd2f0fa264e1edcf98278e01b4cdd09f0',
  #            :scope => 'email, user_friends', :display => 'popup'
end