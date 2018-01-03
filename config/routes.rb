Rails.application.routes.draw do
  match '/404', to: 'error/errors#not_found', via: :all
  match '/500', to: 'error/errors#internal_server_error', via: :all

  # The path '/api' will only reply in JSON
  scope :api, defaults: {format: 'json'} do
    namespace :auth do
      post 'signup', to: 'registrations#create'
      delete 'destroy', to: 'registrations#destroy'
      post 'signin', to: 'sessions#create'
      delete 'signout', to: 'sessions#destroy'
    end
  end
end
