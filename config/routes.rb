Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/policy/:id", to: "policy#show"
    end
  end
end
