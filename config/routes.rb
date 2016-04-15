Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root to: "home#index"

  devise_for :users, controllers: { sessions: "users/sessions" }
  get '/itglue_signin', to: 'itglue_session#create'
end
