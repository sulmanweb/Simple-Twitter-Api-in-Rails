Rails.application.routes.draw do
  match '/404', to: 'error/errors#not_found', via: :all
  match '/500', to: 'error/errors#internal_server_error', via: :all


end
