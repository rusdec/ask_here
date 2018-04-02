Rails.application.routes.draw do
  root to: 'questions#index'

  devise_scope :user do
    get '/sign_in' => 'devise/sessions#new'
    get '/sign_up' => 'devise/registrations#new', as: 'new_user_registration'
  end

  devise_for :users

  resources :questions do
    resources :answers, shallow: true,
                        only: %i[index new create update destroy]
  end

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
end
