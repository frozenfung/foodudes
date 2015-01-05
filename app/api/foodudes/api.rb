module Foodudes
  class API < Grape::API
    version 'v1', using: :path
    format :json

    resource :restaurants do
      desc "Return list of recent posts"
      get do
        Restaurant.all
      end
    end
  end
end