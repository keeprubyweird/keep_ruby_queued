Rails.application.routes.draw do

  default_url_options( host: ENV.fetch('APP_HOST') )

  resources :queued_users, only: [:new, :create]

  scope 'auth/:confirm_token' do
    resources :queued_users, only: [:show, :update, :edit]
    get  'confirm', to: 'confirm_queue#show',  as: 'confirm_queue'
    post 'resend', to: 'confirm_queue#create', as: 'resend_text'
  end

  resources :admin

  # post "queued_user_create", to: 'queued_users#create'
  # get 'queued_users/new', to: 'queued_users#new'

  # scope 'auth/:id/token/:confirm_token' do
  #   patch '/', to: 'queued_users#update'
  #   get   '/', to: 'queued_users#show', as: 'queued_user'

  #   get  'confirm', to: 'confirm_queue#show',   as: 'confirm_queue'
  #   post 'resend', to: 'confirm_queue#create', as: 'resend_text'
  # end

  root 'queued_users#new'

end
