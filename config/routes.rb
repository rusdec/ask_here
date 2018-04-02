Rails.application.routes.draw do
  root to: 'questions#index'

  devise_scope :user do
    delete '/sign_out' => 'devise/sessions#destroy', as: 'sign_out'
    get '/sign_in' => 'devise/sessions#new', as: 'sign_in'
    get '/sign_up' => 'devise/registrations#new', as: 'sign_up'
  end

  devise_for :users

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[index new create update destroy]
  end

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
