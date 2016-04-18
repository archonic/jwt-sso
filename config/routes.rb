Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root to: "home#index"

  devise_for :users, path: "",
    path_names: {sign_in: "login", sign_out: "logout", registration: "profile"},
    controllers: { sessions: "users/sessions" }

  as :user do
    get 'logout', to: 'users/sessions#destroy'
  end

  get '/itglue_signin', to: 'itglue_session#create'
end
