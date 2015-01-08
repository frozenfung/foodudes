module Foodudes
  class API < Grape::API
    version 'v1', using: :path, vendor: 'foodudes'
    format :json
    prefix :grape_api

    resource :restaurants do
      desc "Return list of recent posts."
      get :index do
        Restaurant.all
      end
    end
  end
end
