Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/policy/:id", to: "policy#show"
      get "/policy", to: "policy#index"
    end
  end
end
